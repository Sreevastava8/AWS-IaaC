variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "shopsphere"
}

variable "common_tags" {
  description = "Common tags applied to the ECR repository"
  type        = map(string)
  default     = {}
}