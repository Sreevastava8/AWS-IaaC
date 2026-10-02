variable "name_prefix" {
  description = "Prefix used for naming network resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones used by the VPC"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "database_subnet_cidrs" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
}

variable "management_subnet_cidrs" {
  description = "CIDR blocks for management subnets"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags applied to network resources"
  type        = map(string)
  default     = {}
}