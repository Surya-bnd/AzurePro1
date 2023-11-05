# Resource Group
# 4 VM's -> Diff location
# Traffic Manager
# Peering
# dns proxy

resource "azurerm_resource_group" "azprorg" {
    name = "azurepro1"
    location = "East US"  
}
resource "azurerm_virtual_network" "vneteastus" {
    name = "vneteastus"
    location = azurerm_resource_group.azprorg.location
    resource_group_name = azurerm_resource_group.azprorg.name
    address_space = ["10.0.0.0/16"]
  
}
resource "azurerm_virtual_machine" "azeastus" {
    name = "azureproEUS"
    location = azurerm_resource_group.azprorg.location
    resource_group_name = azurerm_resource_group.azprorg.name
    storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
    storage_os_disk {
      name = "mydisk"
      caching = "ReadWrite"
      create_option = "From Image"
      managed_disk_type = "Standard_LRS"
    }
        vm_size = "Standard_DS2_v3"
        network_interface_ids = [azurerm_network_interface.nieastus.id]
    os_profile {
      computer_name = "eastus1"
      admin_username = "azureuser"
      admin_password = "Matrix1!2@3#"
    }
    os_profile_linux_config {
      disable_password_authentication = "false"
    }
}
resource "azurerm_network_interface" "nieastus" {
    name = "ntweastus"
    location = azurerm_resource_group.azprorg.location
    resource_group_name = azurerm_resource_group.azprorg.name

    ip_configuration {
      name = "ipeastus"
      private_ip_address_allocation = "Dynamic"
    }
  
}

# VM --> Virtual network, Network Interface , Virtual machine [Storage image refrence, Storage OS disk, os profile],

resource "azurerm_virtual_network" "vnindia" {
  name = "centralindiaVN"
  resource_group_name = azurerm_resource_group.azprorg.name
  location = "Central India"
  address_space = ["10.1.0.0/16"]
}

resource "azurerm_network_interface" "niIndia" {
    name = "IndiaNtwInterface"
    resource_group_name = azurerm_resource_group.azprorg.name
    location = "Central India"
  ip_configuration {
    name = "ipcentralIndia"
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_virtual_machine" "centralIndiaVM" {
    name = "VmCentralIndia"
    resource_group_name = azurerm_resource_group.azprorg.name
    location = "Central India"
    vm_size = "standard_d2s_v3"
    network_interface_ids = [azurerm_network_interface.niIndia.id]
    storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
    storage_os_disk {
      name = "mydisk"
      caching = "ReadWrite"
      create_option = "From Image"
      managed_disk_type = "Standard_LRS"
    }
    os_profile {
      computer_name = "India"
      admin_username = "azureuser"
      admin_password = "Matrix1!2@3#"
    }
    os_profile_linux_config {
      disable_password_authentication = "false"
    }
}


resource "azurerm_virtual_network" "vnkorea" {
  name = "KoreaVN"
  resource_group_name = azurerm_resource_group.azprorg.name
  location = "Korea Central"
  address_space = ["10.2.0.0/16"]
}

resource "azurerm_network_interface" "niKorea" {
    name = "KoreaNtwInterface"
    resource_group_name = azurerm_resource_group.azprorg.name
    location = "Korea Central"
  ip_configuration {
    name = "ipcentralKorea"
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_virtual_machine" "centralKoreaVM" {
    name = "VmKorea"
    resource_group_name = azurerm_resource_group.azprorg.name
    location = "Korea Central"
    vm_size = "standard_d2s_v3"
    network_interface_ids = [azurerm_network_interface.niKorea.id]
    storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
    storage_os_disk {
      name = "mydisk"
      caching = "ReadWrite"
      create_option = "From Image"
      managed_disk_type = "Standard_LRS"
    }
    os_profile {
      computer_name = "Korea"
      admin_username = "azureuser"
      admin_password = "Matrix1!2@3#"
    }
    os_profile_linux_config {
      disable_password_authentication = "false"
    }
}

resource "azurerm_virtual_network" "vnAus" {
  name = "AusVN"
  resource_group_name = azurerm_resource_group.azprorg.name
  location = "Australia East"
  address_space = ["10.3.0.0/16"]
}

resource "azurerm_network_interface" "niAustralia" {
    name = "AustraliaNtwInterface"
    resource_group_name = azurerm_resource_group.azprorg.name
    location = "Australia East"
  ip_configuration {
    name = "ipcentralAustralia"
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_virtual_machine" "centralAustraliaVM" {
    name = "VmAustralia"
    resource_group_name = azurerm_resource_group.azprorg.name
    location = "Australia East"
    vm_size = "standard_d2s_v3"
    network_interface_ids = [azurerm_network_interface.niAustralia.id]
    storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
    storage_os_disk {
      name = "mydisk"
      caching = "ReadWrite"
      create_option = "From Image"
      managed_disk_type = "Standard_LRS"
    }
    os_profile {
      computer_name = "Australia"
      admin_username = "azureuser"
      admin_password = "Matrix1!2@3#"
    }
    os_profile_linux_config {
      disable_password_authentication = "false"
    }
}

resource "azurerm_traffic_manager_profile" "mytm" {
  name = "myTM"
  resource_group_name = azurerm_resource_group.azprorg.name
  traffic_routing_method = "Performance"

  dns_config {
    relative_name = azurepro1
    ttl = 100
  }
  monitor_config {
    protocol = "HTTP"
    port = 80
    path = "/"
    interval_in_seconds = 30
    timeout_in_seconds = 9
    tolerated_number_of_failures = 3
  }
}

resource "azurerm_virtual_network_peering" "azurepropeering" {
  name = 
}