############################################################### Variable for Passphrase ############################################################

variable "encryption_passphrase" {
  type = string
  description = "Provide the passphrase to encrypt the state file with pbkdf2"
}

########################################### Variables to create Route53 Hosted Zone ################################################

variable "region" {
  type = string
  description = "Provide the AWS Region into which EKS Cluster to be created"
}

variable "name" {
  description = "Provide the name of the Route53 Hosted Zone"
  type = string
}

variable "env" {
  description = "Provide the Environment Name."
  type = list
}
