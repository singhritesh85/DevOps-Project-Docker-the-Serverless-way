terraform {
  backend "gcs" {
    bucket  = "dolo-dempo"
    prefix  = "state/gcp-artifact-registry"
  }
}

