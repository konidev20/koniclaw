resource "azurerm_recovery_services_vault" "main" {
  name                = local.name_recovery_vault
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"
  storage_mode_type   = "LocallyRedundant"
  soft_delete_enabled = true
  tags                = local.common_tags
}
