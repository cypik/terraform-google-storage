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
  description = "ManagedBy, eg 'cypik'."
}

variable "repository" {
  type        = string
  default     = "https://github.com/cypik/terraform-gcp-storage"
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

variable "storage_class" {
  type        = string
  default     = "STANDARD"
  description = " (Optional, Default: 'STANDARD') The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
}

variable "versioning" {
  type        = bool
  default     = true
  description = "(Optional) The bucket's Versioning configuration. "
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

variable "public_access_prevention" {
  type        = string
  default     = "inherited"
  description = " (Optional) Prevents public access to a bucket. Acceptable values are [inherited] or [enforced]. "
}

variable "labels" {
  type        = map(any)
  default     = {}
  description = "ManagedBy eg 'cypik'."
}