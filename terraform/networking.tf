resource "azurerm_virtual_network" "main" {
  name                = local.name_virtual_network
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [local.vnet_address_space]
  tags                = local.common_tags
}

resource "azurerm_subnet" "main" {
  name                 = local.name_subnet
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.subnet_address_prefix]
}

resource "azurerm_network_security_group" "main" {
  name                = local.name_network_sg
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  # SSH inbound — required for public-IP VM access.
  # Restrict source_address_prefix to your IP range in production.
  security_rule {
    name                       = "allow-ssh-inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.common_tags
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_public_ip" "main" {
  name                = local.name_public_ip
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

resource "azurerm_network_interface" "main" {
  name                = local.name_network_interface
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }

  tags = local.common_tags
}
