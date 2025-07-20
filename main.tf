resource "azurerm_resource_group" "rg" {
  name     = "rg-${terraform.workspace}"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${terraform.workspace}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-${terraform.workspace}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "vm-${terraform.workspace}-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_user

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]

  os_disk {
    name                 = "osdisk-${terraform.workspace}-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_password = var.admin_password
}
resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "nic-${terraform.workspace}-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig-${count.index}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}