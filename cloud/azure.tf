resource "azurerm_resource_group" "nfd" {
  name     = var.main_project_tag
  location = var.location
  tags = merge(
    { "Name" = "${var.main_project_tag}" },
    { "Project" = var.main_project_tag },
  )
}

data "aws_vpc" "nfd31" {
  tags = {
    "Project" = var.main_project_tag
  }
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
      condition     = !contains(data.aws_vpc.nfd31.cidr_block_associations.*.cidr_block, self.address_space.0)
      error_message = "The network CIDR for AWS must not equal Azure for peering purposes."
    }
  }
}