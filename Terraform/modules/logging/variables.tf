variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch Log Group name"
  type        = string
  default     = ""
}

variable "log_retention_days" {
  description = "Number of days to retain application logs"
  type        = number
  default     = 30
}

variable "error_metric_name" {
  description = "Name of the CloudWatch metric for application errors"
  type        = string
  default     = "ApplicationErrors"
}

variable "common_tags" {
  description = "Common tags applied to logging resources"
  type        = map(string)
  default     = {}
}