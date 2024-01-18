# Terraform-google-storage
# Terraform Google Cloud Storage Module
## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Examples](#examples)
- [License](#license)
- [Author](#author)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Introduction
This project deploys a Google Cloud infrastructure using Terraform to create Storage .

## Usage
To use this module, you should have Terraform installed and configured for GCP. This module provides the necessary Terraform configuration for creating GCP resources, and you can customize the inputs as needed. Below is an example of how to use this module:

# Example: storage

```hcl
module "bucket_logs" {
  source      = "cypik/storage/google"
  version     = "1.0.1"
  name        = "logs"
  environment = "test"
  location    = "asia"
}

# bucket with rules.
module "bucket" {
  source      = "cypik/storage/google"
  version     = "1.0.1"
  name        = "app"
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

```
This example demonstrates how to create various GCP resources using the provided modules. Adjust the input values to suit your specific requirements.

## Examples
For detailed examples on how to use this module, please refer to the [Examples](https://github.com/cypik/terraform-google-storage/tree/master/example) directory within this repository.

## Author
Your Name Replace **MIT** and **Cypik** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the **MIT** License - see the [LICENSE](https://github.com/cypik/terraform-google-storage/blob/master/LICENSE) file for details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.50, < 5.11.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.50, < 5.11.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | cypik/labels/google | 1.0.1 |

## Resources

| Name | Type |
|------|------|
| [google_storage_bucket.bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cors"></a> [cors](#input\_cors) | The bucket's Cross-Origin Resource Sharing (CORS) configuration. Multiple blocks of this type are permitted. | `any` | `[]` | no |
| <a name="input_default_event_based_hold"></a> [default\_event\_based\_hold](#input\_default\_event\_based\_hold) | (Optional) Whether or not to automatically apply an eventBasedHold to new objects added to the bucket. | `bool` | `null` | no |
| <a name="input_default_kms_key_name"></a> [default\_kms\_key\_name](#input\_default\_kms\_key\_name) | The bucket's encryption configuration | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | A boolean flag to enable/disable storage . | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | (Optional, Default: false) When deleting a bucket, this boolean option will delete all contained objects | `bool` | `true` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] . | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_labels"></a> [labels](#input\_labels) | ManagedBy eg 'cypik'. | `map(any)` | `{}` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | The bucket's Lifecycle Rules configuration. | `any` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The GCS location. | `string` | `"US"` | no |
| <a name="input_logging"></a> [logging](#input\_logging) | The bucket's Access & Storage Logs configuration. | `any` | `null` | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg 'cypik'. | `string` | `"cypik"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource. Provided by the client when the resource is created. | `string` | `"test"` | no |
| <a name="input_public_access_prevention"></a> [public\_access\_prevention](#input\_public\_access\_prevention) | (Optional) Prevents public access to a bucket. Acceptable values are [inherited] or [enforced]. | `string` | `"inherited"` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Terraform current module repo | `string` | `"https://github.com/cypik/terraform-google-storage"` | no |
| <a name="input_requester_pays"></a> [requester\_pays](#input\_requester\_pays) | (Optional, Default: false) Enables Requester Pays on a storage bucket. | `bool` | `false` | no |
| <a name="input_retention_policy"></a> [retention\_policy](#input\_retention\_policy) | Configuration of the bucket's data retention policy for how long objects in the bucket should be retained. | `any` | `null` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | (Optional, Default: 'STANDARD') The Storage Class of the new bucket. Supported values include: STANDARD, MULTI\_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE. | `string` | `"STANDARD"` | no |
| <a name="input_uniform_bucket_level_access"></a> [uniform\_bucket\_level\_access](#input\_uniform\_bucket\_level\_access) | (Optional, Default: false) Enables Uniform bucket-level access access to a bucket. | `bool` | `false` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | (Optional) The bucket's Versioning configuration. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | List of GCP bucket IDs. |
| <a name="output_bucket_info"></a> [bucket\_info](#output\_bucket\_info) | List of GCP buckets with their details. |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | List of GCP bucket names. |
| <a name="output_bucket_self_links"></a> [bucket\_self\_links](#output\_bucket\_self\_links) | The URI of the created resource. |
| <a name="output_bucket_urls"></a> [bucket\_urls](#output\_bucket\_urls) | The base URL of the bucket, in the format gs://<bucket-name>. |
<!-- END_TF_DOCS -->