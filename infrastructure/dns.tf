resource "azurerm_dns_zone" "this" {
  name                      = "${local.resource_name}.local"
  resource_group_name       = azurerm_resource_group.this.name
}