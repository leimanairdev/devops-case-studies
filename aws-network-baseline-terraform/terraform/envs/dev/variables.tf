variable "name" {
  type        = string
  description = "Project name prefix (used for tags/names)."
}

variable "env" {
  type        = string
  description = "Environment name (dev/staging/prod)."
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy into."
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block."
  default     = "10.10.0.0/16"
}

variable "az_count" {
  type        = number
  description = "Number of Availability Zones to use."
  default     = 2
}
