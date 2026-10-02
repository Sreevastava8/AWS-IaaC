variable "environment" {
  description = "Environment name"
  type        = string
}

variable "jwt_secret" {
  description = "JWT signing secret stored in AWS Secrets Manager"
  type        = string
  sensitive   = true
}

variable "common_tags" {
  description = "Common tags applied to Secrets Manager resources"
  type        = map(string)
  default     = {}
}