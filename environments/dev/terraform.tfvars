rgs = {
  rg1 = {
    name     = "rg-dev-app"
    location = "centralindia"
  }
  rg2 = {
    name     = "rg-dev-app1"
    location = "westus"
  }
}

stor_accs = {
  sa1 = {
    name                     = "stracc034acc01"
    resource_group_name      = "rg-dev-app"
    location                 = "centralindia"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

vnets = {
  vnet1 = {
    name                = "vnet-dev-app"
    location            = "centralindia"
    resource_group_name = "rg-dev-app"
    address_space       = ["10.0.0.0/16"]
    nsg_name            = "dev-vm-nsg"

    subnet1_name          = "subnet-dev-vm"
    subnet1_address_space = ["10.0.2.0/24"]

    # This is for my Azure Bastion host. I will deploy into this dedicated subnet.
    subnet2_name          = "AzureBastionSubnet"
    subnet2_address_space = ["10.0.1.0/24"]
  }
}

pips = {
  pip1 = {
    name                = "dev-vm-public-ip"
    resource_group_name = "rg-dev-app"
    location            = "centralindia"
    allocation_method   = "Static"
  }
}

nics = {
  nic1 = {
    nic_name             = "vm-dev-nic"
    pip_name             = "dev-vm-public-ip"
    subnet_name          = "subnet-dev-vm"
    virtual_network_name = "vnet-dev-app"
    resource_group_name  = "rg-dev-app"
    location             = "centralindia"
  }
}


nsgs = {
  nsg1 = {
    name                = "dev-vm-nsg"
    location            = "centralindia"
    resource_group_name = "rg-dev-app"
  }
}



vms = {
  vm1 = {
    name                = "dev-vm"
    resource_group_name = "rg-dev-app"
    location            = "centralindia"
    network_interface   = "vm-dev-nic"
    size                = "Standard_D2s_v3"
    admin_username      = "adminuser"
    admin_password      = "P@ssw0rd1234"
    publisher           = "Canonical"
    offer               = "0001-com-ubuntu-server-jammy"
    sku                 = "22_04-lts"
    nic_name            = "vm-dev-nic"
  }
}