variable "name" {
  description = "Name prefix for resources."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "az_count" {
  description = "Number of Availability Zones to span."
  type        = number
  default     = 2
}

variable "public_subnet_bits" {
  description = "Number of additional bits to add when calculating public subnet CIDRs."
  type        = number
  default     = 4
}

variable "private_subnet_bits" {
  description = "Number of additional bits to add when calculating private subnet CIDRs."
  type        = number
  default     = 4
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}
