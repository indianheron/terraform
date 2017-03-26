# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}


resource "azurerm_resource_group" "devtestvm" {
  name     = "devtestvm-rg"
  location = "${var.region}"
}

resource "azurerm_virtual_network" "devtestvm" {
  name                = "devtestvm-vn"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.region}"
  resource_group_name = "${azurerm_resource_group.devtestvm.name}"
}

resource "azurerm_subnet" "devtestvm" {
  name                 = "devtestvm-subnet"
  resource_group_name  = "${azurerm_resource_group.devtestvm.name}"
  virtual_network_name = "${azurerm_virtual_network.devtestvm.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "devtestvm" {
  name                = "devtestvm-nic"
  location            = "${var.region}"
  resource_group_name = "${azurerm_resource_group.devtestvm.name}"

  ip_configuration {
    name                          = "devtestvmconfiguration1"
    subnet_id                     = "${azurerm_subnet.devtestvm.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.devtestvm.id}"
  }
}

resource "azurerm_public_ip" "devtestvm" {
  name                         = "devtestvm-pip"
  location                     = "${var.region}"
  resource_group_name          = "${azurerm_resource_group.devtestvm.name}"
  public_ip_address_allocation = "static"

  tags {
    environment = "staging"
  }
}

resource "azurerm_storage_account" "devtestvm" {
  name                = "devyatranewstoacc"
  resource_group_name = "${azurerm_resource_group.devtestvm.name}"
  location            = "${var.region}"
  account_type        = "Standard_LRS"

  tags {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "devtestvm" {
  name                  = "vhds"
  resource_group_name   = "${azurerm_resource_group.devtestvm.name}"
  storage_account_name  = "${azurerm_storage_account.devtestvm.name}"
  container_access_type = "private"
}

resource "azurerm_virtual_machine" "devtestvm" {
  name                  = "devtestvm-vm-1"
  location              = "${var.region}"
  resource_group_name   = "${azurerm_resource_group.devtestvm.name}"
  network_interface_ids = ["${azurerm_network_interface.devtestvm.id}"]
  vm_size               = "Standard_DS2_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "14.04.2-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = "devtestvm-os-disk"
    vhd_uri       = "${azurerm_storage_account.devtestvm.primary_blob_endpoint}${azurerm_storage_container.devtestvm.name}/devtestvm-os-disk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "devtestvm-vm-1"
    admin_username = "ubuntu"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = "true"
    ssh_keys {
    key_data = "${file("${var.key_file_pub}")}"
    path = "/home/ubuntu/.ssh/authorized_keys"
    }
  }

  tags {
    environment = "staging"
  }

  provisioner "local-exec" {
    command = "./script.sh ${azurerm_public_ip.devtestvm.ip_address} ${var.key_file_pri}"
  }
}

output "vm-public-ip" {
  value = "${azurerm_public_ip.devtestvm.ip_address}"
}
