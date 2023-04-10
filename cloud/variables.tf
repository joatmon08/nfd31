variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region"
}

variable "location" {
  type        = string
  default     = "East US"
  description = "Azure location"
}

variable "main_project_tag" {
  type        = string
  description = "Project tag for resources"
  default     = "nfd31"
}

variable "network_cidr" {
  description = "Cidr block for the VPC.  Using a /16 or /20 Subnet Mask is recommended."
  type        = string
  default     = "10.255.0.0/20"
}

variable "allow_cidr_blocks" {
  description = "Allow CIDR Blocks to access HashiCorp Boundary"
  type        = list(string)
  default = [
    "0.0.0.0/0"
  ]
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

variable "boundary_db_username" {
  description = "Boundary database username"
  type        = string
  default     = "boundary"
}