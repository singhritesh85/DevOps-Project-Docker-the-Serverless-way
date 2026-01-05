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

variable "certificate_password" {
  description = "Provide the password for SSL Certificate in .pfx format file"
  type = string
}

variable "SERVER_ACR" {
  description = "Provide the Server Name for Azure Container Registry"
  type = string
}

#variable "USERNAME_ACR" {
#  description = "Provide the Username for Azure Container Registry"
#  type = string 
#}

#variable "PASSWORD_ACR" {
#  description = "Provide the Password for Azure Container Registry"
#  type = string
#}

variable "REPO_NAME" {
  description = "Provide the Repository Name for Azure Container Registry"
  type = string
}

variable "TAG_NUMBER" {
  description = "Provide the Tag Number for Docker Image present in Azure Container Registry"
}

variable "MYSQL_ROOT_PASSWORD" {
  description = "Provide the MySQL Root Password"
  type = string
}

variable "MYSQL_DATABASE" {
  description = "Provide the MySQL Database"
  type = string
}

variable "env" {
  description = "Provide the environment for Azure Resources to be created"
  type = list
}
