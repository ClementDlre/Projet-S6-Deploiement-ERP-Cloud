/*output "public_ip_address" {
  value = azurerm_public_ip.cl_p.ip_address
}
*/
output "odoo-private" {
 value = azurerm_network_interface.nic_odoo_server_nic.private_ip_address
}

output "psql-private" {
  value = azurerm_network_interface.nic_psql_server_nic.private_ip_address
}

output "reverse-proxy-private" {
  value = azurerm_network_interface.nic_reverse_proxy.private_ip_address
}

output "reverse-proxy-public" {
  value = azurerm_public_ip.pip_reverse_proxy.ip_address
}