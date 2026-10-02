resource "aws_iam_role" "eks_cluster" {
  name = "${var.cluster_name}-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = merge(
    var.common_tags,
    {
      Name = "${var.cluster_name}-cluster-role"
    }
  )
}


resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks_nodes" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    var.common_tags,
    {
      Name = "${var.cluster_name}-node-role"
    }
  )
}


resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}


resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}


resource "aws_iam_role_policy_attachment" "eks_ecr_pull_policy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}

resource "aws_security_group" "eks_nodes" {
  name        = "${var.cluster_name}-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id
  tags = merge(
    var.common_tags,
    {
      Name = "${var.cluster_name}-nodes-sg"
    }
  )
}

resource "aws_vpc_security_group_egress_rule" "eks_nodes_all" {
  security_group_id = aws_security_group.eks_nodes.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "eks_nodes_cluster" {
  security_group_id            = aws_security_group.eks_nodes.id
  referenced_security_group_id = aws_eks_cluster.shopsphere.vpc_config[0].cluster_security_group_id
  ip_protocol                  = "-1"
}

resource "aws_eks_cluster" "shopsphere" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  version  = var.kubernetes_version
  access_config {
    authentication_mode = "API"
  }
  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = false
  }
  tags = var.common_tags
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

resource "aws_vpc_security_group_ingress_rule" "eks_nodes_self" {
  security_group_id            = aws_security_group.eks_nodes.id
  referenced_security_group_id = aws_security_group.eks_nodes.id
  ip_protocol                  = "-1"
}

resource "aws_eks_access_entry" "bastion" {
  cluster_name  = aws_eks_cluster.shopsphere.name
  principal_arn = var.bastion_iam_role_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "bastion_admin" {
  cluster_name  = aws_eks_cluster.shopsphere.name
  principal_arn = var.bastion_iam_role_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_entry" "jenkins" {
  cluster_name  = aws_eks_cluster.shopsphere.name
  principal_arn = var.jenkins_iam_role_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "jenkins" {
  cluster_name  = aws_eks_cluster.shopsphere.name
  principal_arn = var.jenkins_iam_role_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"

  access_scope {
    type = "cluster"
  }
}

resource "aws_launch_template" "application" {
  name_prefix = "${var.cluster_name}-application-"

  vpc_security_group_ids = [
    aws_security_group.eks_nodes.id
  ]

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.common_tags,
      {
        Name = "${var.cluster_name}-application-node"
      }
    )
  }
}


resource "aws_eks_node_group" "application" {
  cluster_name    = aws_eks_cluster.shopsphere.name
  node_group_name = "${var.cluster_name}-application"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = var.application_instance_types
  disk_size       = 50

  launch_template {
    id      = aws_launch_template.application.id
    version = aws_launch_template.application.latest_version
  }

  scaling_config {
    desired_size = var.application_desired_size
    min_size     = var.application_min_size
    max_size     = var.application_max_size
  }

  update_config {
    max_unavailable = 1
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.cluster_name}-application"
    }
  )

  depends_on = [
    aws_eks_cluster.shopsphere,
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_pull_policy
  ]
}

resource "aws_launch_template" "system" {
  name_prefix = "${var.cluster_name}-system-"

  vpc_security_group_ids = [
    aws_security_group.eks_nodes.id
  ]

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.common_tags,
      {
        Name = "${var.cluster_name}-system-node"
      }
    )
  }
}

resource "aws_eks_node_group" "system" {
  cluster_name    = aws_eks_cluster.shopsphere.name
  node_group_name = "${var.cluster_name}-system"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = var.system_instance_types
  disk_size       = 50

  launch_template {
    id      = aws_launch_template.system.id
    version = aws_launch_template.system.latest_version
  }

  scaling_config {
    desired_size = var.system_desired_size
    min_size     = var.system_min_size
    max_size     = var.system_max_size
  }

  update_config {
    max_unavailable = 1
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.cluster_name}-system"
    }
  )

  depends_on = [
    aws_eks_cluster.shopsphere,
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_pull_policy
  ]
}