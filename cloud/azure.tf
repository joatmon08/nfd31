resource "azurerm_resource_group" "nfd" {
  name     = var.main_project_tag
  location = var.location
  tags = merge(
    { "Name" = "${var.main_project_tag}" },
    { "Project" = var.main_project_tag },
  )
}

data "aws_vpc" "nfd31" {
  depends_on = [
    module.aws_v2
  ]
  tags = {
    "Project" = var.main_project_tag
  }
}

locals {
  aws_cidr_block_associations = [for c in data.aws_vpc.nfd31.cidr_block_associations : c.cidr_block if c.state == "associated"]
}

resource "azurerm_virtual_network" "nfd" {
  name                = "${var.main_project_tag}-vnet"
  location            = azurerm_resource_group.nfd.location
  resource_group_name = azurerm_resource_group.nfd.name
  address_space       = ["10.252.0.0/20"]

  tags = merge(
    { "Name" = "${var.main_project_tag}" },
    { "Project" = var.main_project_tag },
  )

  lifecycle {
    postcondition {
      condition     = !contains(local.aws_cidr_block_associations, self.address_space.0)
      error_message = "The CIDR blocks for AWS VPCs must not equal Azure virtual networks for peering purposes."
    }
  }
}