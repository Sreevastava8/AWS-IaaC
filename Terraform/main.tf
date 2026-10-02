module "network" {
  source                  = "./modules/network"
  name_prefix             = local.name_prefix
  vpc_cidr                = var.vpc_cidr
  availability_zones      = var.availability_zones
  public_subnet_cidrs     = var.public_subnet_cidrs
  private_subnet_cidrs    = var.private_subnet_cidrs
  database_subnet_cidrs   = var.database_subnet_cidrs
  management_subnet_cidrs = var.management_subnet_cidrs

  common_tags = local.common_tags
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "${local.name_prefix}-application"
  common_tags = local.common_tags
}


module "ecr" {
  source          = "./modules/ecr"
  environment     = var.environment
  repository_name = var.project_name
  common_tags     = local.common_tags
}


module "eks" {
  source                     = "./modules/eks"
  cluster_name               = "${local.name_prefix}-eks"
  vpc_id                     = module.network.vpc_id
  environment                = var.environment
  private_subnet_ids         = module.network.private_subnet_ids
  bastion_iam_role_arn       = module.bastion.bastion_iam_role_arn
  jenkins_iam_role_arn       = var.jenkins_iam_role_arn
  rds_master_user_secret_arn = module.rds.master_user_secret_arn
  jwt_secret_arn             = module.secrets_manager.jwt_secret_arn
  common_tags                = local.common_tags
  depends_on = [
    module.network
  ]
}


module "bastion" {
  source            = "./modules/bastion"
  environment       = var.environment
  ami_id            = var.bastion_ami_id
  private_subnet_id = module.network.private_subnet_ids[0]
  vpc_id            = module.network.vpc_id
  common_tags       = local.common_tags
  depends_on = [
    module.network
  ]
}
resource "aws_vpc_security_group_ingress_rule" "bastion_to_eks" {
  security_group_id            = module.eks.cluster_security_group_id
  referenced_security_group_id = module.bastion.bastion_security_group_id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
}

module "loadbalancer" {
  source                      = "./modules/loadbalancer"
  eks_nodes_security_group_id = module.eks.eks_nodes_security_group_id
  environment                 = var.environment
  vpc_id                      = module.network.vpc_id
  common_tags                 = local.common_tags
  depends_on = [
    module.network
  ]
}


module "rds" {
  source              = "./modules/rds"
  environment         = var.environment
  instance_name       = "${local.name_prefix}-postgres"
  database_name       = var.database_name
  database_version    = var.database_version
  username            = var.database_username
  db_subnet_ids       = module.network.database_subnet_ids
  vpc_id              = module.network.vpc_id
  multi_az            = var.rds_multi_az
  deletion_protection = var.rds_deletion_protection
  skip_final_snapshot = var.rds_skip_final_snapshot
  common_tags         = local.common_tags
  depends_on = [
    module.network,
  ]
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_eks" {
  security_group_id            = module.rds.security_group_id
  referenced_security_group_id = module.eks.eks_nodes_security_group_id

  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"

  description = "Allow PostgreSQL access from EKS nodes to RDS"
}

module "logging" {
  source      = "./modules/logging"
  environment = var.environment
  common_tags = local.common_tags
}


module "secrets_manager" {
  source      = "./modules/secrets-manager"
  environment = var.environment
  jwt_secret  = var.jwt_secret
  common_tags = local.common_tags
}


module "monitoring" {
  source                 = "./modules/monitoring"
  environment            = var.environment
  notification_email     = var.notification_email
  log_group_name         = module.logging.log_group_name
  error_metric_name      = module.logging.error_metric_name
  error_metric_namespace = module.logging.error_metric_namespace
  common_tags            = local.common_tags
  depends_on = [
    module.logging
  ]
}

