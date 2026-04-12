resource "azurerm_storage_account" "main" {
  name                     = local.name_storage_account
  resource_group_name      = azurerm_resource_group.main.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.common_tags
}
