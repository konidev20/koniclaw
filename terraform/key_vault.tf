resource "azurerm_key_vault" "main" {
  name                       = local.name_key_vault
  location                   = var.location
  resource_group_name        = azurerm_resource_group.main.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  tags                       = local.common_tags
}

# Grant the Terraform deployer identity permission to manage secrets.
resource "azurerm_key_vault_access_policy" "terraform" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Purge",
  ]
}

# Store the SSH private key so it can be retrieved via az keyvault secret show.
resource "azurerm_key_vault_secret" "ssh_private_key" {
  name         = local.name_kv_secret_ssh_key
  value        = tls_private_key.vm_ssh.private_key_pem
  key_vault_id = azurerm_key_vault.main.id
  content_type = "application/x-pem-file"
  tags         = local.common_tags

  depends_on = [azurerm_key_vault_access_policy.terraform]
}
