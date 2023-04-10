locals {
  public_cidr_blocks  = [for i in range(var.public_subnet_count) : cidrsubnet(var.network_cidr, 4, i)]
  private_cidr_blocks = [for i in range(var.private_subnet_count) : cidrsubnet(var.network_cidr, 4, i + var.public_subnet_count)]
}