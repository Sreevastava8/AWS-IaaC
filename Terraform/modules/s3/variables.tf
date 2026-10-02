variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to S3 resources"
  type        = map(string)
  default     = {}
}