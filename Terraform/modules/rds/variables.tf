variable "environment" {
  description = "Environment name"
  type        = string
}

variable "instance_name" {
  description = "RDS instance identifier"
  type        = string
}

variable "database_name" {
  description = "Initial PostgreSQL database name"
  type        = string
  default     = "shopsphere"
}

variable "username" {
  description = "Master username for PostgreSQL"
  type        = string
}

variable "database_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "15"
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment for RDS"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Prevent accidental deletion of the RDS instance"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip the final snapshot when the RDS instance is destroyed"
  type        = bool
  default     = true
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 50
}

variable "db_subnet_ids" {
  description = "Private database subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where RDS will be deployed"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to RDS resources"
  type        = map(string)
  default     = {}
}