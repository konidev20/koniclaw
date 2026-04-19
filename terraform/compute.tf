# RSA 4096-bit keypair — private key is stored only in local Terraform state.
# Retrieve after apply: terraform output -raw ssh_private_key > konidev.pem && chmod 600 konidev.pem
resource "tls_private_key" "vm_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Store the public key as a named Azure resource (visible in portal under SSH keys).
resource "azurerm_ssh_public_key" "vm_ssh" {
  name                = local.name_ssh_key_pair
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  public_key          = tls_private_key.vm_ssh.public_key_openssh
  tags                = local.common_tags
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = local.name_virtual_machine
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  size                = "Standard_D2pds_v6"
  admin_username      = var.vm_admin_username
  custom_data         = base64encode(templatefile("${path.module}/cloud-init.yaml", {
    vm_admin_username = var.vm_admin_username
  }))

  network_interface_ids = [azurerm_network_interface.main.id]

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = tls_private_key.vm_ssh.public_key_openssh
  }

  os_disk {
    name                 = local.name_os_disk
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 30
  }

  # Ubuntu Server 24.04 LTS (Noble Numbat) — ARM64
  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server-arm64"
    version   = "latest"
  }

  # Security type: Standard (default — no vTPM, no Secure Boot)
  # vtpm_enabled and secure_boot_enabled are false by default.

  tags = local.common_tags
}
