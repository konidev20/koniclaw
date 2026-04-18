output "resource_group_name" {
  description = "Name of the resource group."
  value       = azurerm_resource_group.main.name
}

output "vm_name" {
  description = "Name of the virtual machine."
  value       = azurerm_linux_virtual_machine.main.name
}

output "vm_public_ip" {
  description = "Public IP address of the VM."
  value       = azurerm_public_ip.main.ip_address
}

output "vm_private_ip" {
  description = "Private IP address of the VM within the VNet."
  value       = azurerm_network_interface.main.private_ip_address
}

output "key_vault_uri" {
  description = "URI of the Key Vault."
  value       = azurerm_key_vault.main.vault_uri
}

output "storage_account_name" {
  description = "Name of the Storage Account."
  value       = azurerm_storage_account.main.name
}

output "ssh_private_key" {
  description = "RSA private key for the VM. Save with: terraform output -raw ssh_private_key > konidev.pem && chmod 600 konidev.pem"
  value       = tls_private_key.vm_ssh.private_key_pem
  sensitive   = true
}

output "key_vault_secret_ssh_id" {
  description = "Key Vault secret ID (versioned URI) for the SSH private key."
  value       = azurerm_key_vault_secret.ssh_private_key.id
}

output "recovery_vault_name" {
  description = "Name of the Recovery Services Vault."
  value       = azurerm_recovery_services_vault.main.name
}

output "recovery_vault_id" {
  description = "Resource ID of the Recovery Services Vault."
  value       = azurerm_recovery_services_vault.main.id
}

output "ai_resource_group_name" {
  description = "Name of the AI Foundry resource group."
  value       = azurerm_resource_group.ai.name
}

output "ai_cognitive_account_name" {
  description = "Name of the Azure AI Services (Cognitive) account."
  value       = azurerm_cognitive_account.main.name
}

output "ai_cognitive_account_endpoint" {
  description = "Endpoint URL for the Azure AI Services account."
  value       = azurerm_cognitive_account.main.endpoint
}

output "ai_cognitive_project_name" {
  description = "Name of the AI Foundry Project."
  value       = azurerm_cognitive_account_project.main.name
}
