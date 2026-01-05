module "azure_vm" {

  source = "../module"
  encryption_passphrase = var.encryption_passphrase
  prefix = var.prefix
  location = var.location[1]

  env = var.env[0]

  ############################ Azure VM ################################# 

  vm_size = var.vm_size[0]
  availability_zone = var.availability_zone
  static_dynamic = var.static_dynamic
  disk_size_gb = var.disk_size_gb
  extra_disk_size_gb = var.extra_disk_size_gb
  computer_name  = var.computer_name
  admin_username = var.admin_username
  admin_password = var.admin_password

  ############################ Create the Azure Container Registry #################################

  acr_sku = var.acr_sku[1]
  admin_enabled = var.admin_enabled

}
