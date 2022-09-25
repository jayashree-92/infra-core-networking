output "hub" {
  value = {
    name                   = var.hub.name
    id                     = azurerm_virtual_hub.hub.id
    default_route_table_id = azurerm_virtual_hub.hub.default_route_table_id
    virtual_router_asn     = azurerm_virtual_hub.hub.virtual_router_asn
    virtual_router_ips     = azurerm_virtual_hub.hub.virtual_router_ips
    firewall               = azurerm_firewall.fw
    firewall_policy        = azurerm_firewall_policy.fwp
  }
}
