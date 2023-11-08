provider "google" {
  project = "opz0-397319"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

#####==============================================================================
##### bucket_logs module call .
#####==============================================================================
module "bucket_logs" {
  source      = "./../"
  name        = "app-logs"
  environment = "test"
  location    = "asia"
}

#####==============================================================================
##### bucket module call .
#####==============================================================================
module "bucket" {
  source      = "./../"
  name        = "appsss"
  environment = "test"
  location    = "asia"

  #logging
  logging = {
    log_bucket        = module.bucket_logs.id
    log_object_prefix = "gcs-log"
  }
  #cors
  cors = [{
    origin          = ["http://image-store.com"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }]
  # versioning
  versioning = true

  #lifecycle_rules
  lifecycle_rules = [{
    action = {
      type          = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
    condition = {
      age                        = 23
      created_before             = "2023-09-7"
      with_state                 = "LIVE"
      matches_storage_class      = ["STANDARD"]
      num_newer_versions         = 10
      custom_time_before         = "1970-01-01"
      days_since_custom_time     = 1
      days_since_noncurrent_time = 1
      noncurrent_time_before     = "1970-01-01"
    }
  }]
}