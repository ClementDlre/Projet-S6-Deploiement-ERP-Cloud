resource "azurerm_virtual_network" "vnet_odoo" {
  name                = "vnet-odoo-vnet-frc"
  resource_group_name = azurerm_resource_group.rg_odoo.name
  location            = azurerm_resource_group.rg_odoo.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "snet_vnet_odoo" {
  name                 = "snet-odoo-vnet-frc"
  virtual_network_name = azurerm_virtual_network.vnet_odoo.name
  resource_group_name  = azurerm_resource_group.rg_odoo.name
  address_prefixes     = ["10.0.1.0/24"]
}