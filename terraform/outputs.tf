output "resource_group_name" {
  description = "Name of the resource group."
  value       = azurerm_resource_group.main.name
}

output "vm_name" {
  description = "Name of the virtual machine."
  value       = azurerm_linux_virtual_machine.main.name
}

output "vm_public_ip" {
  description = "Public IP address of the VM. SSH: ssh -i konidev.pem konidev@<ip>"
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
