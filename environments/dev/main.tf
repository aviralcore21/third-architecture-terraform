module "module_rg" {
  source   = "../../modules/resource_group"
  for_each = var.rgs

  name     = each.value.name
  location = each.value.location
}

module "module_sa" {
  depends_on = [module.module_rg]

  source   = "../../modules/storage_account"
  for_each = var.stor_accs

  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
}

module "module_vnet" {
  depends_on = [module.module_rg]
  source     = "../../modules/virtual_network"

  for_each = var.vnets

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space
  nsg_name            = each.value.nsg_name

  subnet1_name          = each.value.subnet1_name
  subnet1_address_space = each.value.subnet1_address_space

  subnet2_name          = each.value.subnet2_name
  subnet2_address_space = each.value.subnet2_address_space

}

module "module_pip" {
  depends_on = [module.module_rg]
  source     = "../../modules/public_ip"

  for_each = var.pips

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = each.value.allocation_method

}


module "module_nic" {
  depends_on = [module.module_rg, module.module_vnet, module.module_pip]

  source   = "../../modules/nic"
  for_each = var.nics

  location             = each.value.location
  nic_name             = each.value.nic_name
  pip_name             = each.value.pip_name
  subnet_name          = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name

}

module "module_nsg" {
  depends_on = [module.module_vnet, module.module_rg]

  source   = "../../modules/network_security_group"
  for_each = var.nsgs

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
}



module "module_vm" {
  depends_on = [module.module_nic, module.module_vnet, module.module_nsg, module.module_rg]

  source = "../../modules/linux_virtual_machine"

  for_each = var.vms

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.size
  admin_username      = each.value.admin_username
  admin_password      = each.value.admin_password
  publisher           = each.value.publisher
  offer               = each.value.offer
  sku                 = each.value.sku
  nic_name            = each.value.network_interface 
}