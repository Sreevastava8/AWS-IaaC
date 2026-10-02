variable "project_name" {
  description = "Project name"
  type        = string
  default     = "shopsphere"
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "Environment must be one of: dev, qa, or prod."
  }
}

variable "owner" {
  description = "Resource owner"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "availability_zones" {
  description = "AWS Availability Zones"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
}

variable "database_subnet_cidrs" {
  description = "Database subnet CIDR blocks"
  type        = list(string)
}

variable "management_subnet_cidrs" {
  description = "Management subnet CIDR blocks"
  type        = list(string)
}

variable "bastion_ami_id" {
  description = "AMI ID for the bastion EC2 instance"
  type        = string
}

variable "database_username" {
  description = "RDS PostgreSQL username"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "JWT signing secret"
  type        = string
  sensitive   = true
}

variable "notification_email" {
  description = "Email address for CloudWatch monitoring alerts"
  type        = string
}

variable "database_name" {
  description = "Initial RDS PostgreSQL database name"
  type        = string
  default     = "shopsphere"
}

variable "database_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "15"
}

variable "rds_multi_az" {
  description = "Enable Multi-AZ deployment for RDS"
  type        = bool
}

variable "rds_deletion_protection" {
  description = "Enable RDS deletion protection"
  type        = bool
}

variable "rds_skip_final_snapshot" {
  description = "Skip final RDS snapshot on destruction"
  type        = bool
}

variable "jenkins_iam_role_arn" {
  description = "ARN of the IAM role manually attached to the Jenkins EC2 instance"
  type        = string
}