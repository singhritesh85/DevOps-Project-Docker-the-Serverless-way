variable "encryption_passphrase" {
  type = string
  description = "Provide the passphrase to encrypt the state file with pbkdf2"
}

variable "prefix" {
  type        = string
  description = "Provide the prefix of the Resource Name to be created"
}

variable "location" {
  type        = list
  description = "Provide the location into which the Azure Resource to be created"
}

variable "dns_zone_name" {
  type        = string
  description = "Provide the DNS Zone Name"  
}
