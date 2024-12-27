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

## Examples

### Example: bucket
```hcl
module "bucket" {
  source      = "cypik/storage/google"
  version     = "v1.0.2"
  name        = "bucket"
  environment = "test"
  location    = "us"
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

  iam_members = [{
    role   = "roles/storage.objectViewer"
    member = "group:test-gcp-ops@test.blueprints.joonix.net"
  }]

  autoclass                = true
  set_hmac_access          = true
  public_access_prevention = "enforced"
}
```

### Example: bucket_with_encryption
```hcl
module "bucket" {
  source      = "cypik/storage/google"
  version     = "v1.0.2"
  name        = "bucket-encryption"
  environment = "test"
  location    = "US"
  encryption = {
    kms_key = module.kms_key.key_id
  }

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
    data_locations = ["US-EAST4", "US-WEST1"]
  }

  iam_members = [
    {
      role   = "roles/storage.admin"
      member = "group:test-gcp-ops@test.blueprints.joonix.net"
    }
  ]
  autoclass = true
}
```
This example demonstrates how to create various GCP resources using the provided modules. Adjust the input values to suit your specific requirements.

## Examples
For detailed examples on how to use this module, please refer to the [Examples](https://github.com/cypik/terraform-google-storage/tree/master/examples) directory within this repository.

## Author
Your Name Replace **MIT** and **Cypik** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the **MIT** License - see the [LICENSE](https://github.com/cypik/terraform-google-storage/blob/master/LICENSE) file for details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.9.5 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >=6.1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >=6.1.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.6.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | cypik/labels/google | 1.0.2 |

## Resources

| Name | Type |
|------|------|
| [google_storage_bucket.bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.members](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_object.folders](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) | resource |
| [google_storage_hmac_key.hmac_keys](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_hmac_key) | resource |
| [random_id.bucket_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoclass"></a> [autoclass](#input\_autoclass) | When true, enables autoclass for the bucket, which automatically optimizes storage class for the objects based on access patterns. | `bool` | `false` | no |
| <a name="input_bucket_policy_only"></a> [bucket\_policy\_only](#input\_bucket\_policy\_only) | Enables Bucket Policy Only access to the bucket, ensuring that only policies are used for access control. | `bool` | `true` | no |
| <a name="input_buckets_name"></a> [buckets\_name](#input\_buckets\_name) | Name of the resource. Provided by the client when the resource is created. | `list(string)` | `null` | no |
| <a name="input_cors"></a> [cors](#input\_cors) | Set of maps of mixed type attributes for CORS values. See appropriate attribute types here: https://www.terraform.io/docs/providers/google/r/storage_bucket.html#cors. | `set(any)` | `[]` | no |
| <a name="input_custom_placement_config"></a> [custom\_placement\_config](#input\_custom\_placement\_config) | Configuration for the bucket's custom location in a dual-region setup. Set to null for single or multi-region buckets. | <pre>object({<br>    data_locations = list(string)<br>  })</pre> | `null` | no |
| <a name="input_encryption"></a> [encryption](#input\_encryption) | Specifies a Cloud KMS key for encrypting objects in the bucket. If set to 'null', a new keyring and key pair will be created. | <pre>object({<br>    kms_key = optional(string, null)<br>  })</pre> | <pre>{<br>  "kms_key": null<br>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Additional tags for the resource. | `map(string)` | `{}` | no |
| <a name="input_folders"></a> [folders](#input\_folders) | Map of lowercase unprefixed name => list of top level folder objects. | `map(list(string))` | `{}` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | When set to true, allows deletion of the bucket along with all contained objects. If false, the deletion will fail if objects are present. | `bool` | `false` | no |
| <a name="input_hmac_service_accounts"></a> [hmac\_service\_accounts](#input\_hmac\_service\_accounts) | List of HMAC service accounts to grant access to GCS. | `map(string)` | `{}` | no |
| <a name="input_iam_members"></a> [iam\_members](#input\_iam\_members) | A list of IAM members to whom permissions will be granted on the bucket, defined by their roles. | <pre>list(object({<br>    role   = string<br>    member = string<br>  }))</pre> | `[]` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,]. | `list(string)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to be attached to the buckets. | `map(string)` | `{}` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | Configuration of the bucket's lifecycle rules, defining actions such as deleting or changing the storage class of objects based on specified conditions. | <pre>list(object({<br>    action    = any<br>    condition = any<br>  }))</pre> | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | Bucket location. | `string` | `""` | no |
| <a name="input_log_bucket"></a> [log\_bucket](#input\_log\_bucket) | Specifies the bucket that will receive log objects generated by this bucket. | `string` | `null` | no |
| <a name="input_log_object_prefix"></a> [log\_object\_prefix](#input\_log\_object\_prefix) | Prefix for log object names. If not provided, GCS defaults to the name of this bucket. | `string` | `null` | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg 'info@cypik.com'. | `string` | `"info@cypik.com"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource. Provided by the client when the resource is created. | `string` | `""` | no |
| <a name="input_public_access_prevention"></a> [public\_access\_prevention](#input\_public\_access\_prevention) | Prevents public access to a bucket. Acceptable values are inherited or enforced. If inherited, the bucket uses public access prevention, only if the bucket is subject to the public access prevention organization policy constraint. | `string` | `"inherited"` | no |
| <a name="input_randomize_suffix"></a> [randomize\_suffix](#input\_randomize\_suffix) | Adds an identical, but randomized 4-character suffix to all bucket names. | `bool` | `false` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Terraform current module repo. | `string` | `"https://github.com/cypik/terraform-google-storage"` | no |
| <a name="input_retention_policy"></a> [retention\_policy](#input\_retention\_policy) | Defines the data retention policy for the bucket, specifying how long objects should be retained and whether the policy is locked. | <pre>object({<br>    is_locked        = bool<br>    retention_period = number<br>  })</pre> | `null` | no |
| <a name="input_set_hmac_access"></a> [set\_hmac\_access](#input\_set\_hmac\_access) | Set S3 compatible access to GCS. | `bool` | `false` | no |
| <a name="input_soft_delete_policy"></a> [soft\_delete\_policy](#input\_soft\_delete\_policy) | Configuration for soft delete policies, specifying how long objects can be retained after deletion, following the format in the provider documentation. | <pre>object({<br>    retention_duration_seconds = optional(number)<br>  })</pre> | `{}` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | Bucket storage class. | `string` | `"STANDARD"` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | Enables versioning for the bucket. When set to true, all objects will have versioning enabled. | `bool` | `true` | no |
| <a name="input_website"></a> [website](#input\_website) | Map of website values. Supported attributes: main\_page\_suffix, not\_found\_page. | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_encryption_keys"></a> [bucket\_encryption\_keys](#output\_bucket\_encryption\_keys) | The encryption keys used for encrypting data in the bucket. |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The ID of the created storage bucket in Google Cloud. |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | The name of the Google Cloud Storage bucket. |
| <a name="output_bucket_self_links"></a> [bucket\_self\_links](#output\_bucket\_self\_links) | The self-link URI of the Google Cloud Storage bucket, used for API references. |
| <a name="output_bucket_url"></a> [bucket\_url](#output\_bucket\_url) | The full URL to access the Google Cloud Storage bucket. |
| <a name="output_hmac_keys"></a> [hmac\_keys](#output\_hmac\_keys) | List of HMAC keys. |
<!-- END_TF_DOCS -->