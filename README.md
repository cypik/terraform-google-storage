# terraform-gcp-storage
# Google Cloud Infrastructure Provisioning with Terraform
## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Module Inputs](#module-inputs)
- [Module Outputs](#module-outputs)
- [License](#license)

## Introduction
This project deploys a Google Cloud infrastructure using Terraform to create STORAGE .
## Usage
To use this module, you should have Terraform installed and configured for GCP. This module provides the necessary Terraform configuration for creating GCP resources, and you can customize the inputs as needed. Below is an example of how to use this module:
# Example: storage
```hcl
module "bucket_logs" {
  source      = "git::https://github.com/opz0/terraform-gcp-storage.git?ref=v1.0.0"
  name        = "logs"
  environment = "test"
  location    = "asia"
}

# bucket with rules.
module "bucket" {
  sourc       = "git::https://github.com/opz0/terraform-gcp-storage.git?ref=v1.0.0"
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

## Module Inputs

- 'name'  : The name of the service account.
- 'environment': The environment type.
- 'project_id' : The GCP project ID.
- 'location': The GCS location.
- 'website': Configuration if the bucket acts as a website.
- 'logging' : The bucket's Access & Storage Logs configuration.
- 'versioning' :The bucket's Versioning configuration.
- 'condition' : The Lifecycle Rule's condition configuration.

## Module Outputs
Each module may have specific outputs. You can retrieve these outputs by referencing the module in your Terraform configuration.

- 'id' : The ID of the s3 bucket.
- 'url' : The base URL of the bucket, in the format gs://<bucket-name>
- 'self_link': URI of the GCS bucket.
- 'name' : All attributes of the created `google_storage_bucket` resource.

## Examples
For detailed examples on how to use this module, please refer to the 'examples' directory within this repository.

## Author
Your Name Replace '[License Name]' and '[Your Name]' with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/opz0/terraform-gcp-storage/blob/master/LICENSE) file for details.
