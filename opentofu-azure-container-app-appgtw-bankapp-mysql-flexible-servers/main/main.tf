module "aca" {
  source = "../module"
   
  encryption_passphrase = var.encryption_passphrase

  prefix = var.prefix

  location = var.location[1]

  certificate_password = var.certificate_password

  SERVER_ACR = var.SERVER_ACR

#  USERNAME_ACR = var.USERNAME_ACR

#  PASSWORD_ACR = var.PASSWORD_ACR

  REPO_NAME = var.REPO_NAME

  TAG_NUMBER = var.TAG_NUMBER

  MYSQL_ROOT_PASSWORD = var.MYSQL_ROOT_PASSWORD

  MYSQL_DATABASE = var.MYSQL_DATABASE

  env = var.env[0]
}
