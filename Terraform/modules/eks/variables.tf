variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs where EKS will run"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags applied to EKS resources"
  type        = map(string)
  default     = {}
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.33"
}

variable "application_instance_types" {
  description = "EC2 instance types for application nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "system_instance_types" {
  description = "EC2 instance types for system nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "application_desired_size" {
  description = "Desired number of application nodes"
  type        = number
  default     = 2
}

variable "application_min_size" {
  description = "Minimum number of application nodes"
  type        = number
  default     = 1
}

variable "application_max_size" {
  description = "Maximum number of application nodes"
  type        = number
  default     = 4
}

variable "system_desired_size" {
  description = "Desired number of system nodes"
  type        = number
  default     = 2
}

variable "system_min_size" {
  description = "Minimum number of system nodes"
  type        = number
  default     = 1
}

variable "system_max_size" {
  description = "Maximum number of system nodes"
  type        = number
  default     = 3
}

variable "vpc_id" {
  description = "VPC ID for EKS resources"
  type        = string
}

variable "bastion_iam_role_arn" {
  description = "IAM role ARN of the bastion host"
  type        = string
}

variable "rds_master_user_secret_arn" {
  description = "ARN of the RDS-managed master credentials secret"
  type        = string
}

variable "jwt_secret_arn" {
  description = "ARN of the application JWT secret in AWS Secrets Manager"
  type        = string
}

variable "jenkins_iam_role_arn" {
  description = "IAM role ARN manually attached to the Jenkins EC2 instance"
  type        = string
}