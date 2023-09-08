variable "name" {
  type        = string
  default     = "test"
  description = "Name of the resource. Provided by the client when the resource is created. "
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] ."
}

variable "managedby" {
  type        = string
  default     = ""
  description = "ManagedBy, eg 'Opz0'."
}

variable "repository" {
  type        = string
  default     = ""
  description = "Terraform current module repo"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable storage ."
}

variable "location" {
  type        = string
  default     = "US"
  description = "(Required) The GCS location."
}

variable "force_destroy" {
  type        = bool
  default     = true
  description = " (Optional, Default: false) When deleting a bucket, this boolean option will delete all contained objects"
}

variable "project_id" {
  type        = string
  default     = "opz0-397319"
  description = "(Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}

variable "storage_class" {
  type        = string
  default     = "STANDARD"
  description = " (Optional, Default: 'STANDARD') The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
}

variable "autoclass" {
  type        = bool
  default     = true
  description = "(Optional) The bucket's Autoclass configuration."
}

variable "versioning" {
  type        = bool
  default     = true
  description = "(Optional) The bucket's Versioning configuration. "
}

variable "website" {
  type        = map(any)
  default     = null
  description = "Map of website values. Supported attributes: main_page_suffix, not_found_page"
}

variable "default_event_based_hold" {
  type        = bool
  default     = null
  description = "(Optional) Whether or not to automatically apply an eventBasedHold to new objects added to the bucket."
}

variable "retention_policy" {
  type        = any
  default     = null
  description = "Configuration of the bucket's data retention policy for how long objects in the bucket should be retained."
}

variable "logging" {
  type        = any
  default     = null
  description = "The bucket's Access & Storage Logs configuration."
}

variable "default_kms_key_name" {
  type        = string
  default     = null
  description = "The bucket's encryption configuration"
}

variable "cors" {
  type        = any
  default     = []
  description = "The bucket's Cross-Origin Resource Sharing (CORS) configuration. Multiple blocks of this type are permitted."
}

variable "lifecycle_rules" {
  type        = any
  default     = []
  description = "The bucket's Lifecycle Rules configuration."
}

variable "google_storage_bucket_iam_member_enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

variable "requester_pays" {
  type        = bool
  default     = false
  description = " (Optional, Default: false) Enables Requester Pays on a storage bucket."
}

variable "uniform_bucket_level_access" {
  type        = bool
  default     = false
  description = "(Optional, Default: false) Enables Uniform bucket-level access access to a bucket."
}

variable "custom_placement_config" {
  type        = list(any)
  default     = []
  description = " (Optional) The bucket's custom location configuration, which specifies the individual regions that comprise a dual-region bucket. If the bucket is designated a single or multi-region, the parameters are empty."
}

variable "public_access_prevention" {
  type        = string
  default     = "inherited"
  description = " (Optional) Prevents public access to a bucket. Acceptable values are [inherited] or [enforced]. "
}

variable "bucket_id" {
  type        = string
  default     = ""
  description = "Used to find the parent resource to bind the IAM policy to"
}

variable "labels" {
  type        = map(any)
  default     = {}
  description = "ManagedBy eg 'Opz0'."
}