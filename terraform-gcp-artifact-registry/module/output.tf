output "repository_endpoint" {
  description = "The registry URI for the Docker repository"
  value       = google_artifact_registry_repository.google_container_registry.registry_uri
}

output "repository_url" {
  description = "The full URI of the created GCP Artifact Registry repository"
  value       = google_artifact_registry_repository.google_container_registry.id
}
