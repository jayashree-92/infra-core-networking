output "vnet_spoke" {
  value = {
    rids             = random_string.rids
    vnet             = azurerm_virtual_network.vnet
    subnets          = azurerm_subnet.subnets
    vhub_connection  = azurerm_virtual_hub_connection.vhc
    nsgs             = azurerm_network_security_group.nsgs
    nsg_associations = azurerm_subnet_network_security_group_association.nsg_associations
  }
}
