variable "name" {
  type        = string
  default     = ""
  description = "Name of the resource. Provided by the client when the resource is created."
}

variable "buckets_name" {
  type        = list(string)
  default     = null
  description = "Name of the resource. Provided by the client when the resource is created."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(string)
  default     = ["name", "environment"]
  description = "Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,]."
}

variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags for the resource."
}

variable "managedby" {
  type        = string
  default     = "info@cypik.com"
  description = "ManagedBy, eg 'info@cypik.com'."
}

variable "repository" {
  type        = string
  default     = "https://github.com/cypik/terraform-google-storage"
  description = "Terraform current module repo."
}

variable "prefix" {
  type        = string
  default     = ""
  description = "Prefix used to generate the bucket name."
}

variable "randomize_suffix" {
  type        = bool
  default     = false
  description = "Adds an identical, but randomized 4-character suffix to all bucket names."
}

variable "location" {
  type        = string
  default     = ""
  description = "Bucket location."
}

variable "storage_class" {
  type        = string
  default     = "STANDARD"
  description = "Bucket storage class."
}

variable "force_destroy_multi" {
  type        = map(bool)
  default     = {}
  description = "Optional map of lowercase unprefixed name => boolean, defaults to false."
}

variable "iam_members" {
  type = list(object({
    role   = string
    member = string
  }))
  default     = []
  description = "A list of IAM members to whom permissions will be granted on the bucket, defined by their roles."
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "When set to true, allows deletion of the bucket along with all contained objects. If false, the deletion will fail if objects are present."
}

variable "versioning_multi" {
  type        = map(bool)
  default     = {}
  description = "Optional map of lowercase unprefixed name => boolean, defaults to false."
}

variable "versioning" {
  type        = bool
  default     = true
  description = "Enables versioning for the bucket. When set to true, all objects will have versioning enabled."
}

variable "autoclass_multi" {
  type        = map(bool)
  default     = {}
  description = "Optional map of lowercase unprefixed bucket name => boolean, defaults to false."
}

variable "autoclass" {
  type        = bool
  default     = false
  description = "When true, enables autoclass for the bucket, which automatically optimizes storage class for the objects based on access patterns."
}

variable "encryption_key_names" {
  type        = map(string)
  default     = {}
  description = "Optional map of lowercase unprefixed name => string, empty strings are ignored."
}

variable "encryption" {
  type = object({
    default_kms_key_name = string
  })
  default     = null
  description = "Specifies a Cloud KMS key for encrypting objects in the bucket. If set to 'null', a new keyring and key pair will be created."
}

variable "bucket_policy_only_multi" {
  type        = map(bool)
  default     = {}
  description = "Disable ad-hoc ACLs on specified buckets. Defaults to true. Map of lowercase unprefixed name => boolean."
}

variable "bucket_policy_only" {
  type        = bool
  default     = true
  description = "Enables Bucket Policy Only access to the bucket, ensuring that only policies are used for access control."
}

variable "default_event_based_hold" {
  type        = map(bool)
  default     = {}
  description = "Enable event based hold to new objects added to specific bucket. Defaults to false. Map of lowercase unprefixed name => boolean."
}

variable "admins" {
  type        = list(string)
  default     = []
  description = "IAM-style members who will be granted roles/storage.objectAdmin on all buckets."
}

variable "creators" {
  type        = list(string)
  default     = []
  description = "IAM-style members who will be granted roles/storage.objectCreators on all buckets."
}

variable "viewers" {
  type        = list(string)
  default     = []
  description = "IAM-style members who will be granted roles/storage.objectViewer on all buckets."
}

variable "hmac_key_admins" {
  type        = list(string)
  default     = []
  description = "IAM-style members who will be granted roles/storage.hmacKeyAdmin on all buckets."
}

variable "storage_admins" {
  type        = list(string)
  default     = []
  description = "IAM-style members who will be granted roles/storage.admin on all buckets."
}

variable "bucket_admins" {
  type        = map(string)
  default     = {}
  description = "Map of lowercase unprefixed name => comma-delimited IAM-style per-bucket admins."
}

variable "bucket_creators" {
  type        = map(string)
  default     = {}
  description = "Map of lowercase unprefixed name => comma-delimited IAM-style per-bucket creators."
}

variable "bucket_viewers" {
  type        = map(string)
  default     = {}
  description = "Map of lowercase unprefixed name => comma-delimited IAM-style per-bucket viewers."
}

variable "bucket_hmac_key_admins" {
  type        = map(string)
  default     = {}
  description = "Map of lowercase unprefixed name => comma-delimited IAM-style per-bucket HMAC Key admins."
}

variable "bucket_storage_admins" {
  type        = map(string)
  default     = {}
  description = "Map of lowercase unprefixed name => comma-delimited IAM-style per-bucket storage admins."
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Labels to be attached to the buckets."
}

variable "folders" {
  type        = map(list(string))
  default     = {}
  description = "Map of lowercase unprefixed name => list of top level folder objects."
}

variable "set_admin_roles" {
  type        = bool
  default     = false
  description = "Grant roles/storage.objectAdmin role to admins and bucket_admins."
}

variable "set_creator_roles" {
  type        = bool
  default     = false
  description = "Grant roles/storage.objectCreator role to creators and bucket_creators."
}

variable "set_viewer_roles" {
  type        = bool
  default     = false
  description = "Grant roles/storage.objectViewer role to viewers and bucket_viewers."
}

variable "set_hmac_key_admin_roles" {
  type        = bool
  default     = false
  description = "Grant roles/storage.hmacKeyAdmin role to hmac_key_admins and bucket_hmac_key_admins."
}

variable "set_storage_admin_roles" {
  type        = bool
  default     = false
  description = "Grant roles/storage.admin role to storage_admins and bucket_storage_admins."
}

variable "lifecycle_rules" {
  type = list(object({
    action    = any
    condition = any
  }))
  default     = []
  description = "Configuration of the bucket's lifecycle rules, defining actions such as deleting or changing the storage class of objects based on specified conditions."
}

variable "log_bucket" {
  type        = string
  default     = null
  description = "Specifies the bucket that will receive log objects generated by this bucket."
}

variable "log_object_prefix" {
  type        = string
  default     = null
  description = "Prefix for log object names. If not provided, GCS defaults to the name of this bucket."
}

variable "bucket_lifecycle_rules" {
  type = map(set(object({
    action    = map(string)
    condition = map(string)
  })))
  default     = {}
  description = "Additional lifecycle_rules for specific buckets. Map of lowercase unprefixed name => list of lifecycle rules to configure."
}

variable "cors" {
  type        = set(any)
  default     = []
  description = "Set of maps of mixed type attributes for CORS values. See appropriate attribute types here: https://www.terraform.io/docs/providers/google/r/storage_bucket.html#cors."
}

variable "website" {
  type        = map(any)
  default     = {}
  description = "Map of website values. Supported attributes: main_page_suffix, not_found_page."
}

variable "retention_policy_multi" {
  type        = any
  default     = {}
  description = "Map of retention policy values. Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket#retention_policy."
}

variable "retention_policy" {
  type = object({
    is_locked        = bool
    retention_period = number
  })
  default     = null
  description = "Defines the data retention policy for the bucket, specifying how long objects should be retained and whether the policy is locked."
}

variable "custom_placement_config_multi" {
  type        = any
  default     = {}
  description = "Map of lowercase unprefixed name => custom placement config object. Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket#custom_placement_config."
}

variable "custom_placement_config" {
  type = object({
    data_locations = list(string)
  })
  default     = null
  description = "Configuration for the bucket's custom location in a dual-region setup. Set to null for single or multi-region buckets."
}

variable "logging" {
  type        = any
  default     = {}
  description = "Map of lowercase unprefixed name => bucket logging config object. Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#logging."
}

variable "set_hmac_access" {
  type        = bool
  default     = false
  description = "Set S3 compatible access to GCS."
}

variable "hmac_service_accounts" {
  type        = map(string)
  default     = {}
  description = "List of HMAC service accounts to grant access to GCS."
}

variable "public_access_prevention" {
  type        = string
  default     = "inherited"
  description = "Prevents public access to a bucket. Acceptable values are inherited or enforced. If inherited, the bucket uses public access prevention, only if the bucket is subject to the public access prevention organization policy constraint."
}

variable "soft_delete_policy_multi" {
  type        = map(any)
  default     = {}
  description = "Soft delete policies to apply. Map of lowercase unprefixed name => soft delete policy. Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#nested_soft_delete_policy."
}

variable "soft_delete_policy" {
  type = object({
    retention_duration_seconds = optional(number)
  })
  default     = {}
  description = "Configuration for soft delete policies, specifying how long objects can be retained after deletion, following the format in the provider documentation."
}