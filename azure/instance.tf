provider "azurerm" {
  version = "=2.20.0"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "gamez-rg" {
  name     = "gamez-rg"
  location = "eastus"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "gamez-net" {
  name                = "gamez-net"
  resource_group_name = azurerm_resource_group.gamez-rg.name
  location            = azurerm_resource_group.gamez-rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "gamez-subnet" {
  name                 = "gamez-subnet"
  resource_group_name  = azurerm_resource_group.gamez-rg.name
  virtual_network_name = azurerm_virtual_network.gamez-net.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "gamez-pub-ip" {
  name                = "GamezPubIP"
  resource_group_name = azurerm_resource_group.gamez-rg.name
  location            = azurerm_resource_group.gamez-rg.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "gamez-nic" {
  name                = "gamez-nic"
  location            = azurerm_resource_group.gamez-rg.location
  resource_group_name = azurerm_resource_group.gamez-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.gamez-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.gamez-pub-ip.id
  }
}

resource "azurerm_windows_virtual_machine" "gamez-vm" {
  name                = "gamez-vm"
  resource_group_name = azurerm_resource_group.gamez-rg.name
  location            = azurerm_resource_group.gamez-rg.location
  size                = "Standard_F2"
  #Standard_NC6_Promo
  admin_username = "guybrush"
  admin_password = "uFightL1ke@c0w"
  custom_data    = base64encode(file("userdata.ps1"))
  network_interface_ids = [
    azurerm_network_interface.gamez-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "gamez-bootstrap" {
  depends_on           = [ azurerm_windows_virtual_machine.gamez-vm ]
  name                 = "gamez-bootstrap"
  virtual_machine_id   = azurerm_windows_virtual_machine.gamez-vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell -Command \"cp c:/azuredata/customdata.bin c:/azuredata/bootstrap.ps1; c:/azuredata/bootstrap.ps1; exit 0\""
    }
SETTINGS
}