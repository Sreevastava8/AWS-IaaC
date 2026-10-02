variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for the bastion host"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the bastion host"
  type        = string
  default     = "t3.micro"
}

variable "private_subnet_id" {
  description = "Private subnet ID for the SSM management instance"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the bastion security group will be created"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to AWS resources"
  type        = map(string)
  default     = {}
}

