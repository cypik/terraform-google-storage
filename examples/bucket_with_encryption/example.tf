provider "google" {
  project = "soy-smile-435017-c5"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

module "kms_key" {
  source          = "cypik/kms/google"
  version         = "1.0.3"
  name            = "app"
  environment     = "test"
  location        = "US"
  prevent_destroy = true
  keys            = ["test"]
  role            = ["roles/owner"]
}

# Bucket module with encryption using the KMS key
module "bucket" {
  source      = "./../../"
  name        = "bucket-encryption"
  environment = "test"
  location    = "US"
  encryption = {
    kms_key = module.kms_key.key_id
  }

  lifecycle_rules = [{
    action = {
      type = "Delete"
    }
    condition = {
      age            = 365
      with_state     = "ANY"
      matches_prefix = "test12"
    }
  }]

  custom_placement_config = {
    data_locations = ["US-EAST4", "US-WEST1"]
  }

  iam_members = [
    {
      role   = "roles/storage.admin"
      member = "group:test-gcp-ops@test.blueprints.joonix.net"
    }
  ]
  autoclass = true
}