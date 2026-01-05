########################## Google Container Registry ##################################

resource "google_artifact_registry_repository" "google_container_registry" {
  location      = var.gcp_region
  repository_id = "${var.prefix}-gcr-${var.env}"
  description   = "Docker Registry for the BankApp Project"
  mode          = "STANDARD_REPOSITORY"
  format        = "DOCKER"
  vulnerability_scanning_config {
    enablement_config = "INHERITED"     ###"DISABLED"
  }
}
