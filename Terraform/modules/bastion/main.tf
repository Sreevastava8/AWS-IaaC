resource "aws_security_group" "bastion" {
  name        = "${var.environment}-bastion-sg"
  description = "Security group for the ${var.environment} bastion host"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow outbound traffic"

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-bastion-sg"
    }
  )
}


resource "aws_iam_role" "bastion" {
  name = "${var.environment}-bastion-role"
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
      Name = "${var.environment}-bastion-role"
    }
  )
}

resource "aws_iam_role_policy" "bastion_eks" {
  name = "${var.environment}-bastion-eks"
  role = aws_iam_role.bastion.id
  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "eks:DescribeCluster"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bastion_ssm" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_instance_profile" "bastion" {
  name = "${var.environment}-bastion-profile"
  role = aws_iam_role.bastion.name

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-bastion-profile"
    }
  )
}


resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = var.private_subnet_id

  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.bastion.id
  ]

  iam_instance_profile = aws_iam_instance_profile.bastion.name

  user_data = <<-EOF
  #!/bin/bash

  dnf update -y
  dnf install -y amazon-ssm-agent
  systemctl enable amazon-ssm-agent
  systemctl start amazon-ssm-agent

  dnf install -y unzip

  curl -LO "https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl"
  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  rm -f kubectl

  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
EOF

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-bastion"
    }
  )
}