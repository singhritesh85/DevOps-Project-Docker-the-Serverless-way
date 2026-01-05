################################################################# Variables for Azure VM ##############################################################

variable "encryption_passphrase" {
  type = string
  description = "Provide the passphrase to encrypt the state file with pbkdf2"
}

variable "prefix" {
  description = "Provide the prefix for Azure Resources to be created"
  type = string
}

variable "location" {
  description = "Provide the Location into which Azure Resources to be created"
  type = list
}

variable "vm_size" {
  type = list
  description = "Provide the Size of the Azure VM"
}

variable "availability_zone" {
  type = list
  description = "Provide the Availability Zone into which the VM to be created"
}

variable "static_dynamic" {
  type = list
  description = "Select the Static or Dynamic"
}

variable "disk_size_gb" {
  type = number
  description = "Provide the Disk Size in GB"
}

variable "extra_disk_size_gb" {
  type = number
  description = "Provide the Size of Extra Disk to be Attached"
}

variable "computer_name" {
  type = string
  description = "Provide the Hostname"
}

variable "admin_username" {
  type = string
  description = "Provid the Administrator Username"
}

variable "admin_password" {
  type = string
  description = "Provide the Administrator Password"
}

variable "env" {
  description = "Provide the environment for Azure Resources to be created"
  type = list
}

################################################### Variables to create Azure Container Registry ######################################################

variable "acr_sku" {
  type = list
  description = "Selection the SKU among Basic, Standard and Premium"
}

variable "admin_enabled" {
  type = bool
  description = "The ACR accessibility is Admin enabled or not."
}
