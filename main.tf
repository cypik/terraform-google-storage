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
  suffix       = var.randomize_suffix ? random_id.bucket_suffix[0].hex : ""
  names_set    = toset(var.buckets_name)
  buckets_list = var.buckets_name != null ? [for name in var.buckets_name : google_storage_bucket.buckets[name]] : []
  first_bucket = length(local.buckets_list) > 0 ? local.buckets_list[0] : null
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
resource "google_storage_bucket" "buckets" {
  for_each = var.buckets_name != null ? local.names_set : toset([])

  name                     = join("-", compact([var.prefix, each.value, module.labels.id, local.suffix]))
  project                  = data.google_client_config.current.project
  location                 = var.location
  storage_class            = var.storage_class
  labels                   = merge(var.labels, { name = replace(join("-", compact([var.prefix, each.value])), ".", "-") })
  public_access_prevention = var.public_access_prevention

  force_destroy = lookup(
    var.force_destroy_multi,
    lower(each.value),
    false,
  )
  uniform_bucket_level_access = lookup(
    var.bucket_policy_only_multi,
    lower(each.value),
    true,
  )
  versioning {
    enabled = lookup(
      var.versioning_multi,
      lower(each.value),
      false,
    )
  }
  default_event_based_hold = lookup(
    var.default_event_based_hold,
    lower(each.value),
    false,
  )
  autoclass {
    enabled = lookup(
      var.autoclass_multi,
      lower(each.value),
      false,
    )
  }
  dynamic "encryption" {
    for_each = trimspace(lookup(var.encryption_key_names, lower(each.value), "")) != "" ? [true] : []
    content {
      default_kms_key_name = trimspace(
        lookup(
          var.encryption_key_names,
          lower(each.value),
          "Error retrieving kms key name",
        )
      )
    }
  }
  dynamic "cors" {
    for_each = var.cors
    content {
      origin          = lookup(cors.value, "origin", null)
      method          = lookup(cors.value, "method", null)
      response_header = lookup(cors.value, "response_header", null)
      max_age_seconds = lookup(cors.value, "max_age_seconds", null)
    }
  }
  dynamic "website" {
    for_each = length(keys(var.website)) == 0 ? toset([]) : toset([var.website])
    content {
      main_page_suffix = lookup(website.value, "main_page_suffix", null)
      not_found_page   = lookup(website.value, "not_found_page", null)
    }
  }

  dynamic "retention_policy" {
    for_each = lookup(var.retention_policy_multi, each.value, null) != null ? [var.retention_policy_multi[each.value]] : []
    content {
      is_locked        = lookup(retention_policy.value, "is_locked", null)
      retention_period = lookup(retention_policy.value, "retention_period", null)
    }
  }

  dynamic "custom_placement_config" {
    for_each = lookup(var.custom_placement_config_multi, each.value, null) != null ? [var.custom_placement_config_multi[each.value]] : []
    content {
      data_locations = lookup(custom_placement_config.value, "data_locations", null)
    }
  }

  dynamic "lifecycle_rule" {
    for_each = setunion(var.lifecycle_rules, lookup(var.bucket_lifecycle_rules, each.value, toset([])))
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lookup(lifecycle_rule.value.action, "storage_class", null)
      }
      condition {
        age                        = lookup(lifecycle_rule.value.condition, "age", null)
        created_before             = lookup(lifecycle_rule.value.condition, "created_before", null)
        with_state                 = lookup(lifecycle_rule.value.condition, "with_state", contains(keys(lifecycle_rule.value.condition), "is_live") ? (lifecycle_rule.value.condition["is_live"] ? "LIVE" : null) : null)
        matches_storage_class      = contains(keys(lifecycle_rule.value.condition), "matches_storage_class") ? split(",", lifecycle_rule.value.condition["matches_storage_class"]) : null
        matches_prefix             = contains(keys(lifecycle_rule.value.condition), "matches_prefix") ? split(",", lifecycle_rule.value.condition["matches_prefix"]) : null
        matches_suffix             = contains(keys(lifecycle_rule.value.condition), "matches_suffix") ? split(",", lifecycle_rule.value.condition["matches_suffix"]) : null
        num_newer_versions         = lookup(lifecycle_rule.value.condition, "num_newer_versions", null)
        custom_time_before         = lookup(lifecycle_rule.value.condition, "custom_time_before", null)
        days_since_custom_time     = lookup(lifecycle_rule.value.condition, "days_since_custom_time", null)
        days_since_noncurrent_time = lookup(lifecycle_rule.value.condition, "days_since_noncurrent_time", null)
        noncurrent_time_before     = lookup(lifecycle_rule.value.condition, "noncurrent_time_before", null)
      }
    }
  }

  dynamic "logging" {
    for_each = lookup(var.logging, each.value, null) != null ? { v = lookup(var.logging, each.value) } : {}
    content {
      log_bucket        = lookup(logging.value, "log_bucket", null)
      log_object_prefix = lookup(logging.value, "log_object_prefix", null)
    }
  }

  dynamic "soft_delete_policy" {
    for_each = [lookup(var.soft_delete_policy_multi, each.value, {
      retention_duration_seconds = null
    })]
    content {
      retention_duration_seconds = lookup(soft_delete_policy.value, "retention_duration_seconds", null)
    }
  }
}

resource "google_storage_bucket_iam_binding" "admins" {
  for_each = var.set_admin_roles ? local.names_set : []
  bucket   = google_storage_bucket.buckets[each.value].name
  role     = "roles/storage.objectAdmin"
  members = compact(
    concat(
      var.admins,
      split(
        ",",
        lookup(var.bucket_admins, each.value, ""),
      ),
    ),
  )
}

resource "google_storage_bucket_iam_binding" "creators" {
  for_each = var.set_creator_roles ? local.names_set : toset([])
  bucket   = google_storage_bucket.buckets[each.value].name
  role     = "roles/storage.objectCreator"
  members = compact(
    concat(
      var.creators,
      split(
        ",",
        lookup(var.bucket_creators, each.value, ""),
      ),
    ),
  )
}

resource "google_storage_bucket_iam_binding" "viewers" {
  for_each = var.set_viewer_roles ? local.names_set : toset([])
  bucket   = google_storage_bucket.buckets[each.value].name
  role     = "roles/storage.objectViewer"
  members = compact(
    concat(
      var.viewers,
      split(
        ",",
        lookup(var.bucket_viewers, each.value, ""),
      ),
    ),
  )
}

resource "google_storage_bucket_iam_binding" "hmac_key_admins" {
  for_each = var.set_hmac_key_admin_roles ? local.names_set : toset([])
  bucket   = google_storage_bucket.buckets[each.key].name
  role     = "roles/storage.hmacKeyAdmin"
  members = compact(
    concat(
      var.hmac_key_admins,
      split(
        ",",
        lookup(var.bucket_hmac_key_admins, each.key, ""),
      ),
    ),
  )
}

resource "google_storage_bucket_iam_binding" "storage_admins" {
  for_each = var.set_storage_admin_roles ? local.names_set : toset([])
  bucket   = google_storage_bucket.buckets[each.value].name
  role     = "roles/storage.admin"
  members = compact(
    concat(
      var.storage_admins,
      split(
        ",",
        lookup(var.bucket_storage_admins, each.value, ""),
      ),
    ),
  )
}

resource "google_storage_bucket_object" "folders" {
  for_each = { for obj in local.folder_list : "${obj.bucket}_${obj.folder}" => obj }
  bucket   = google_storage_bucket.buckets[each.value.bucket].name
  name     = "${each.value.folder}/"
  content  = "foo"
}

resource "google_storage_hmac_key" "hmac_keys" {
  project               = data.google_client_config.current.project
  for_each              = var.set_hmac_access ? var.hmac_service_accounts : {}
  service_account_email = each.key
  state                 = each.value
}

##simple_bucket created
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
    for_each = var.encryption.default_kms_key_name != null && var.encryption.default_kms_key_name != "" ? [1] : []

    content {
      default_kms_key_name = var.encryption.default_kms_key_name
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
  count  = length(var.iam_members)              # Ensure it only counts over iam_members
  bucket = google_storage_bucket.bucket[0].name # Always refer to the first bucket since you only have one
  role   = var.iam_members[count.index].role
  member = var.iam_members[count.index].member
}