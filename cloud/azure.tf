resource "azurerm_resource_group" "nfd" {
  name     = var.main_project_tag
  location = var.location
  tags = merge(
    { "Name" = "${var.main_project_tag}" },
    { "Project" = var.main_project_tag },
  )
}

resource "azurerm_virtual_network" "nfd" {
  name                = "${var.main_project_tag}-vnet"
  location            = azurerm_resource_group.nfd.location
  resource_group_name = azurerm_resource_group.nfd.name
  address_space       = [var.network_cidr]

  tags = merge(
    { "Name" = "${var.main_project_tag}" },
    { "Project" = var.main_project_tag },
  )

  lifecycle {
    postcondition {
      condition     = self.address_space.0 != module.aws.vpc_cidr_block
      error_message = "The network CIDR for AWS must not equal Azure for peering purposes."
    }
  }
}