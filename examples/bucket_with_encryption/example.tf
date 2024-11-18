provider "google" {
  project = "soy-smile-435017-c5"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

#####==============================================================================
##### bucket module call .
#####==============================================================================
module "bucket" {
  source      = "./../../"
  name        = "bucket-encryption"
  environment = "test"
  location    = "us"
  encryption  = local.kms_key_enabled ? { default_kms_key_name = module.encryption_key.key_id } : null # Pass null if KMS is not enabled

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
    data_locations : ["US-EAST4", "US-WEST1"]
  }

  iam_members = [
    {
      role   = "roles/storage.admin"
      member = "group:test-gcp-ops@test.blueprints.joonix.net"
    }
  ]
  autoclass = true
}
