variable "region" {
  type        = string
  description = "AWS Region"
}

variable "main_project_tag" {
  type        = string
  description = "Project tag for resources"
}

variable "network_cidr" {
  description = "Cidr block for the VPC.  Using a /16 or /20 Subnet Mask is recommended."
  type        = string
}

variable "public_subnet_count" {
  description = "The number of public subnets to create.  Cannot exceed the number of AZs in your selected region.  2 is more than enough."
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "The number of private subnets to create.  Cannot exceed the number of AZs in your selected region."
  type        = number
  default     = 2
}