module "artifact_registry" {

source = "../module"
gcp_region = var.gcp_region[1]
project_name = var.project_name
prefix = var.prefix
env = var.env[0]

}
