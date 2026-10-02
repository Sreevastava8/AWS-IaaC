project_name = "shopsphere"
environment  = "dev"
owner        = "shopsphere"
region       = "ap-south-1"

availability_zones = [
  "ap-south-1a",
  "ap-south-1b"
]

vpc_cidr = "10.10.0.0/16"

public_subnet_cidrs = [
  "10.10.1.0/24",
  "10.10.5.0/24"
]

private_subnet_cidrs = [
  "10.10.2.0/24",
  "10.10.6.0/24"
]

database_subnet_cidrs = [
  "10.10.3.0/24",
  "10.10.7.0/24"
]

management_subnet_cidrs = [
  "10.10.4.0/24",
  "10.10.8.0/24"
]

bastion_ami_id          = "ami-066c4849e6b3a1e3d"
database_name           = "shopsphere"
database_version        = "15"
database_username       = "shopsphere_admin"
rds_multi_az            = false
rds_deletion_protection = false
rds_skip_final_snapshot = true
jwt_secret              = "CHANGE_ME_TO_A_STRONG_RANDOM_SECRET"
jenkins_iam_role_arn    = "arn:aws:iam::992839646359:role/shopsphere-jenkins"
notification_email      = "email@gmail.com"