resource "azurerm_virtual_network" "vnet" {
  name                = "var.name"
  location            = "var.location"
  resource_group_name = "var.resource_group_name"
  address_space       = "var.address_space"

  subnet {
    name             = "var.subnet1_name"
    address_prefixes = "var.subnet1_address_space"
    security_group = data.azurerm_network_security_group.nsg.id
  }

  subnet {
    name             = "var.subnet2_name"
    address_prefixes = "var.subnet2_address_space"
  }
}