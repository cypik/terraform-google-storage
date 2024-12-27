module "labels" {
  source      = "cypik/labels/google"
  version     = "1.0.2"
  name        = var.name
  environment = var.environment
  label_order = var.label_order
  managedby   = var.managedby
  repository  = var.repository
  extra_tags  = var.extra_tags
}

data "google_client_config" "current" {
}

resource "random_id" "bucket_suffix" {
  count       = var.randomize_suffix ? 1 : 0
  byte_length = 2
}

locals {
  folder_list = flatten([
    for bucket, folders in var.folders : [
      for folder in folders : {
        bucket = bucket,
        folder = folder
      }
    ]
  ])
}

#####==============================================================================
##### Creates a new bucket in Google cloud storage service (GCS).
#####==============================================================================
#tfsec:ignore:google-storage-bucket-encryption-customer-key
#tfsec:ignore:google-storage-enable-ubla
resource "google_storage_bucket" "bucket" {
  count                       = var.buckets_name == null ? 1 : 0
  name                        = module.labels.id
  project                     = data.google_client_config.current.project
  location                    = var.location
  storage_class               = var.storage_class
  uniform_bucket_level_access = var.bucket_policy_only
  labels                      = var.labels
  force_destroy               = var.force_destroy
  public_access_prevention    = var.public_access_prevention

  versioning {
    enabled = var.versioning
  }

  autoclass {
    enabled = var.autoclass
  }

  dynamic "retention_policy" {
    for_each = var.retention_policy == null ? [] : [var.retention_policy]
    content {
      is_locked        = var.retention_policy.is_locked
      retention_period = var.retention_policy.retention_period
    }
  }

  dynamic "encryption" {
    for_each = var.encryption.kms_key != null && var.encryption.kms_key != "" ? [1] : []

    content {
      default_kms_key_name = var.encryption.kms_key
    }
  }
  dynamic "website" {
    for_each = length(keys(var.website)) == 0 ? toset([]) : toset([var.website])
    content {
      main_page_suffix = lookup(website.value, "main_page_suffix", null)
      not_found_page   = lookup(website.value, "not_found_page", null)
    }
  }

  dynamic "cors" {
    for_each = var.cors == null ? [] : var.cors
    content {
      origin          = lookup(cors.value, "origin", null)
      method          = lookup(cors.value, "method", null)
      response_header = lookup(cors.value, "response_header", null)
      max_age_seconds = lookup(cors.value, "max_age_seconds", null)
    }
  }

  dynamic "custom_placement_config" {
    for_each = var.custom_placement_config == null ? [] : [var.custom_placement_config]
    content {
      data_locations = var.custom_placement_config.data_locations
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lookup(lifecycle_rule.value.action, "storage_class", null)
      }
      condition {
        age                        = lookup(lifecycle_rule.value.condition, "age", null)
        send_age_if_zero           = lookup(lifecycle_rule.value.condition, "send_age_if_zero", null)
        created_before             = lookup(lifecycle_rule.value.condition, "created_before", null)
        with_state                 = lookup(lifecycle_rule.value.condition, "with_state", null)
        matches_storage_class      = contains(keys(lifecycle_rule.value.condition), "matches_storage_class") ? split(",", lifecycle_rule.value.condition["matches_storage_class"]) : null
        matches_prefix             = contains(keys(lifecycle_rule.value.condition), "matches_prefix") ? [lifecycle_rule.value.condition["matches_prefix"]] : []
        matches_suffix             = lookup(lifecycle_rule.value.condition, "matches_suffix", null)
        num_newer_versions         = lookup(lifecycle_rule.value.condition, "num_newer_versions", null)
        custom_time_before         = lookup(lifecycle_rule.value.condition, "custom_time_before", null)
        days_since_custom_time     = lookup(lifecycle_rule.value.condition, "days_since_custom_time", null)
        days_since_noncurrent_time = lookup(lifecycle_rule.value.condition, "days_since_noncurrent_time", null)
        noncurrent_time_before     = lookup(lifecycle_rule.value.condition, "noncurrent_time_before", null)
      }
    }
  }

  dynamic "logging" {
    for_each = var.log_bucket == null ? [] : [var.log_bucket]
    content {
      log_bucket        = var.log_bucket
      log_object_prefix = var.log_object_prefix
    }
  }

  dynamic "soft_delete_policy" {
    for_each = var.soft_delete_policy == {} ? [] : [var.soft_delete_policy]
    content {
      retention_duration_seconds = lookup(soft_delete_policy.value, "retention_duration_seconds", null)
    }
  }
}

resource "google_storage_bucket_iam_member" "members" {
  count  = length(var.iam_members)
  bucket = google_storage_bucket.bucket[0].name
  role   = var.iam_members[count.index].role
  member = var.iam_members[count.index].member
}

resource "google_storage_bucket_object" "folders" {
  for_each = { for obj in local.folder_list : "${obj.bucket}_${obj.folder}" => obj }
  bucket   = google_storage_bucket.bucket[each.value.bucket].name
  name     = "${each.value.folder}/"
  content  = "foo"
}

resource "google_storage_hmac_key" "hmac_keys" {
  project               = data.google_client_config.current.project
  for_each              = var.set_hmac_access ? var.hmac_service_accounts : {}
  service_account_email = each.key
  state                 = each.value
}