provider "google" {
  project = "soy-smile-435017-c5"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

#####==============================================================================
##### bucket module call .
#####==============================================================================
module "cloud_storage" {
  source           = "./../../"
  prefix           = "multiple-buckets"
  buckets_name     = ["one", "two"]
  environment      = "test"
  randomize_suffix = true
  bucket_policy_only_multi = {
    "one" = true
    "two" = false
  }

  folders = {
    "two" = ["dev", "prod"]
  }

  lifecycle_rules = [
    {
      action = {
        type          = "SetStorageClass"
        storage_class = "NEARLINE"
      }
      condition = {
        age                   = "10"
        matches_storage_class = "MULTI_REGIONAL,STANDARD,DURABLE_REDUCED_AVAILABILITY"
      }
    }
  ]

  bucket_lifecycle_rules = {
    "one" = [
      {
        action = {
          type = "Delete"
        }
        condition = {
          age = "90"
        }
      }
    ]
  }

  retention_policy_multi = {
    "two" = {
      is_locked        = false
      retention_period = 1
    }
  }

  default_event_based_hold = {
    "one" = true
  }
}