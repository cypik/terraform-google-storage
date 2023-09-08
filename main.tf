module "labels" {
  source = "git::git@github.com:opz0/terraform-gcp-labels.git?ref=master"

  name        = var.name
  environment = var.environment
  label_order = var.label_order
  managedby   = var.managedby
  repository  = var.repository
}

#####==============================================================================
##### Creates a new bucket in Google cloud storage service (GCS).
#####==============================================================================
resource "google_storage_bucket" "bucket" {
  count                       = var.enabled ? 1 : 0
  name                        = module.labels.id
  project                     = var.project_id
  location                    = var.location
  labels                      = var.labels
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = var.uniform_bucket_level_access
  storage_class               = var.storage_class
  default_event_based_hold    = var.default_event_based_hold
  public_access_prevention    = var.public_access_prevention
  requester_pays              = var.requester_pays

  dynamic "encryption" {
    for_each = var.default_kms_key_name != null ? ["encryption"] : []
    content {
      default_kms_key_name = var.default_kms_key_name
    }
  }

  dynamic "logging" {
    for_each = var.logging != null ? ["logging"] : []

    content {
      log_bucket        = var.logging.log_bucket
      log_object_prefix = var.logging.log_object_prefix
    }
  }

  dynamic "retention_policy" {
    for_each = var.retention_policy != null ? ["retention_policy"] : []

    content {
      retention_period = var.retention_policy.retention_period
      is_locked        = try(var.retention_policy.is_locked, null)
    }
  }

  dynamic "cors" {
    for_each = var.cors

    content {
      origin          = try(cors.value.origin, null)
      method          = try(cors.value.method, null)
      response_header = try(cors.value.response_header, null)
      max_age_seconds = try(cors.value.max_age_seconds, null)
    }
  }

  versioning {
    enabled = var.versioning
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules

    content {
      action {
        storage_class = lifecycle_rule.value.action.type == "SetStorageClass" ? lifecycle_rule.value.action.storage_class : null
        type          = lifecycle_rule.value.action.type
      }

      condition {
        age                        = try(lifecycle_rule.value.condition.age, null)
        created_before             = try(lifecycle_rule.value.condition.created_before, null)
        noncurrent_time_before     = try(lifecycle_rule.value.condition.noncurrent_time_before, null)
        matches_storage_class      = try(lifecycle_rule.value.condition.matches_storage_class, null)
        num_newer_versions         = try(lifecycle_rule.value.condition.num_newer_versions, null)
        custom_time_before         = try(lifecycle_rule.value.condition.custom_time_before, null)
        days_since_custom_time     = try(lifecycle_rule.value.condition.days_since_custom_time, null)
        with_state                 = try(lifecycle_rule.value.condition.with_state, null)
        days_since_noncurrent_time = try(lifecycle_rule.value.condition.days_since_noncurrent_time, null)
      }
    }
  }
}



