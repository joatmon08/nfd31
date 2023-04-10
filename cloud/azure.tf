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
}