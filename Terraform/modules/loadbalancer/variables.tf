variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB and target group are deployed"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to the ALB resources"
  type        = map(string)
  default     = {}
}

variable "eks_nodes_security_group_id" {
  description = "Security group ID of the EKS worker nodes"
  type        = string
}