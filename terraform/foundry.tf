resource "azurerm_resource_group" "ai" {
  name     = local.name_resource_group_ai
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_storage_account" "ai" {
  name                     = local.name_storage_account_ai
  resource_group_name      = azurerm_resource_group.ai.name
  location                 = var.location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  is_hns_enabled           = false
  tags                     = local.common_tags
}

resource "azurerm_key_vault" "ai" {
  name                       = local.name_key_vault_ai
  location                   = var.location
  resource_group_name        = azurerm_resource_group.ai.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 90
  purge_protection_enabled   = true
  tags                       = local.common_tags
}

# Grant the Terraform deployer full Key Vault management access.
resource "azurerm_role_assignment" "deployer_kv_ai" {
  scope                = azurerm_key_vault.ai.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_ai_foundry" "main" {
  name                = local.name_ai_foundry
  location            = var.location
  resource_group_name = azurerm_resource_group.ai.name
  storage_account_id  = azurerm_storage_account.ai.id
  key_vault_id        = azurerm_key_vault.ai.id

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

# Grant the Hub's managed identity access to its storage account and key vault.
resource "azurerm_role_assignment" "ai_foundry_kv" {
  scope                = azurerm_key_vault.ai.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azurerm_ai_foundry.main.identity[0].principal_id
}
