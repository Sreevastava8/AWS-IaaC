project_name = "shopsphere"
environment  = "qa"
owner        = "shopsphere"
region       = "ap-south-1"

availability_zones = [
  "ap-south-1a",
  "ap-south-1b"
]

vpc_cidr = "10.20.0.0/16"

public_subnet_cidrs = [
  "10.20.1.0/24",
  "10.20.5.0/24"
]

private_subnet_cidrs = [
  "10.20.2.0/24",
  "10.20.6.0/24"
]

database_subnet_cidrs = [
  "10.20.3.0/24",
  "10.20.7.0/24"
]

management_subnet_cidrs = [
  "10.20.4.0/24",
  "10.20.8.0/24"
]

bastion_ami_id          = "ami-066c4849e6b3a1e3d"
database_name           = "shopsphere"
database_version        = "15"
database_username       = "shopsphere_admin"
rds_multi_az            = true
rds_deletion_protection = false
rds_skip_final_snapshot = true
jwt_secret              = "CHANGE_ME_TO_A_STRONG_RANDOM_SECRET"
jenkins_iam_role_arn    = "arn:aws:iam::992839646359:role/shopsphere-jenkins"
notification_email      = "Sreevastava09@gmail.com"