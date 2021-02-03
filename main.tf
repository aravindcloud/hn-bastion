provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group
  location = var.location
  tags = {environment = var.tag
  }
}
resource "azurerm_network_security_group" "nsg" {
  name                = "${azurerm_resource_group.main.name}-SecurityGroup"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                        = "rdp"
    priority                    = "100"
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "tcp"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }

  tags = azurerm_resource_group.main.tags
}

resource "azurerm_virtual_network" "main" {
  name                = var.virtual_network_name
  address_space       = [var.address_space]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_prefix]
}

resource "azurerm_subnet_network_security_group_association" "test" {
  subnet_id                 = "${azurerm_subnet.internal.id}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm" {
  count = var.vm_count
  name = "vm-${count.index + 1}"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size = var.vm_size

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = element(split("/", var.vm_image_string), 0)
    offer = element(split("/", var.vm_image_string), 1)
    sku = element(split("/", var.vm_image_string), 2)
    version = element(split("/", var.vm_image_string), 3)
  }

  storage_os_disk {
    name = "vm-${count.index + 1}-OS-Disk"
    caching = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option = "FromImage"
  }

  # Optional data disks
  storage_data_disk {
    name = "vm-${count.index + 1}-Data-Disk"
    disk_size_gb = "25"
    managed_disk_type = "Standard_LRS"
    create_option = "Empty"
    lun = 0
  }

  os_profile {
    computer_name = "healthnow${count.index + 1}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

}
