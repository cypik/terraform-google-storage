output "bucket_id" {
  value       = module.bucket.bucket_id
  description = "The ID of the GCP bucket from the module."
}

output "bucket_self_links" {
  value       = module.bucket.bucket_self_links
  description = "The self-link URI of the GCP bucket, used for API references."
}

output "bucket_name" {
  value       = module.bucket.bucket_name
  description = "The name of the GCP bucket, as well as all attributes of the created google_storage_bucket resource."
}

output "bucket_url" {
  value       = module.bucket.bucket_url
  description = "The full URL to access the Google Cloud Storage bucket."
}

output "bucket_encryption_keys" {
  value       = module.bucket.bucket_encryption_keys
  description = "The encryption keys used for encrypting data in the bucket."
}