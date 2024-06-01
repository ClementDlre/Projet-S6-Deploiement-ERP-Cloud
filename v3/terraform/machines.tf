###########################################
#                Serveur ODOO             #
###########################################

resource "azurerm_network_interface" "nic_odoo_server_nic" {
  name                = "nic-odoo-server-nic-frc"
  resource_group_name = azurerm_resource_group.rg_odoo.name
  location            = azurerm_resource_group.rg_odoo.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.snet_vnet_odoo.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.10"
  }
}

resource "azurerm_linux_virtual_machine" "odoo_server" {
  name                            = "odoo-server-frc"
  resource_group_name             = azurerm_resource_group.rg_odoo.name
  location                        = azurerm_resource_group.rg_odoo.location
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.nic_odoo_server_nic.id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  admin_ssh_key {
    public_key = file("/home/vagrant/.ssh/id_rsa.pub") 
    username = "adminuser"
  }
}

###########################################
#                Serveur psql             #
###########################################

resource "azurerm_network_interface" "nic_psql_server_nic" {
  name                = "nic-psql-server-nic-frc"
  resource_group_name = azurerm_resource_group.rg_odoo.name
  location            = azurerm_resource_group.rg_odoo.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.snet_vnet_odoo.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.11"
  }
}

resource "azurerm_linux_virtual_machine" "psql_server" {
  name                            = "psql-server-frc"
  resource_group_name             = azurerm_resource_group.rg_odoo.name
  location                        = azurerm_resource_group.rg_odoo.location
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.nic_psql_server_nic.id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  admin_ssh_key {
    public_key = file("/home/vagrant/.ssh/id_rsa.pub") 
    username = "adminuser"
  }

}

###########################################
#                Reverse proxy            #
###########################################
resource "azurerm_linux_virtual_machine" "reverse_proxy" {
  name                            = "reverse-proxy-frc"
  resource_group_name             = azurerm_resource_group.rg_odoo.name
  location                        = azurerm_resource_group.rg_odoo.location
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.nic_reverse_proxy.id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  admin_ssh_key {
    public_key = file("/home/vagrant/.ssh/id_rsa.pub") 
    username = "adminuser"
  }
}

resource "azurerm_public_ip" "pip_reverse_proxy" {

  name                = "pip-reverse-proxy-frc"
  resource_group_name = azurerm_resource_group.rg_odoo.name
  location            = azurerm_resource_group.rg_odoo.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic_reverse_proxy" {
  name                = "nic-reverse-proxy-nic-frc"
  resource_group_name = azurerm_resource_group.rg_odoo.name
  location            = azurerm_resource_group.rg_odoo.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.snet_vnet_odoo.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.12"
    public_ip_address_id = azurerm_public_ip.pip_reverse_proxy.id
  }
}

