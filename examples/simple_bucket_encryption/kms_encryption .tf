data "google_client_config" "current" {
}

data "google_storage_project_service_account" "gcs_account" {
  project = data.google_client_config.current.project
}

locals {
  kms_key_enabled = true
}

resource "random_string" "bucket_suffix" {
  length = 1
}

#####==============================================================================
##### KMS Key Module Call
#####==============================================================================
module "encryption_key" {
  source          = "cypik/kms/google"
  version         = "1.0.2"
  name            = "simple-bucket-${random_string.bucket_suffix.result}" # Append index and random string to the bucket name
  location        = "us"
  prevent_destroy = false

  decrypters = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
  encrypters = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}