output "vnet" {
  value = {
    vnet             = azurerm_virtual_network.vnet
    subnets          = azurerm_subnet.subnets
    nsgs             = azurerm_network_security_group.nsgs
    nsg_associations = azurerm_subnet_network_security_group_association.nsg_associations
  }
}
