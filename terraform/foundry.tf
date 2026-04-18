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

resource "azurerm_cognitive_account" "main" {
  name                = local.name_cognitive_account
  location            = var.location
  resource_group_name = azurerm_resource_group.ai.name
  kind                = "AIServices"
  sku_name            = "S0"

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

resource "azurerm_cognitive_account_project" "main" {
  name                 = local.name_cognitive_project
  cognitive_account_id = azurerm_cognitive_account.main.id
  location             = var.location

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}
