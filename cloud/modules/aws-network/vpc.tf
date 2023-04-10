data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "group-name"
    values = [var.region]
  }
}

# Main VPC resource
resource "aws_vpc" "nfd" {
  cidr_block                       = var.network_cidr
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = merge(
    { "Name" = "${var.main_project_tag}-vpc" },
    { "Project" = var.main_project_tag },
  )
}