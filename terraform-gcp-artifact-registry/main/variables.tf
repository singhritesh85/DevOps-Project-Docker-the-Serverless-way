variable "project_name" {
  description = "Provide the project name for GCP Account"
  type = string
}

variable "gcp_region" {
  description = "Provide the GCP Region in which Resources to be created"
  type = list
}

variable "prefix" {
  description = "Provide the prefix name for the GCP Resources to be created"
  type = string
}

variable "env" {
  description = "Provide the Environment Name into which the resources to be created"
  type = list
}
