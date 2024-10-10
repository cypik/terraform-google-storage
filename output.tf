# Outputs for all buckets
output "buckets_id" {
  value       = local.first_bucket
  description = "Bucket resource (for single use)."
}

output "buckets_url" {
  value       = local.first_bucket != null ? local.first_bucket.url : null
  description = "Bucket URL (for single use)."
}

output "buckets_list" {
  value       = local.buckets_list
  description = "Bucket resources as list."
}

output "buckets_map" {
  value       = google_storage_bucket.buckets
  description = "Bucket resources by name."
}

output "buckets_self_links" {
  value       = { for k, v in google_storage_bucket.buckets : k => v.self_link }
  description = "URI of the GCP bucket."
}

output "names" {
  value       = { for name, bucket in google_storage_bucket.buckets : name => bucket.name }
  description = "Bucket names."
}

output "urls" {
  value       = { for name, bucket in google_storage_bucket.buckets : name => bucket.url }
  description = "Bucket URLs."
}

output "names_list" {
  value       = local.buckets_list[*].name
  description = "List of bucket names."
}

output "urls_list" {
  value       = local.buckets_list[*].url
  description = "List of bucket URLs."
}

output "hmac_keys" {
  value       = google_storage_hmac_key.hmac_keys[*]
  sensitive   = true
  description = "List of HMAC keys."
}

## Simple bucket outputs
output "bucket_id" {
  value       = google_storage_bucket.bucket
  description = "The ID of the created storage bucket in Google Cloud."
}

output "bucket_name" {
  value       = [for i in range(length(google_storage_bucket.bucket)) : google_storage_bucket.bucket[i].name]
  description = "The name of the Google Cloud Storage bucket."
}

output "bucket_url" {
  value       = [for i in range(length(google_storage_bucket.bucket)) : google_storage_bucket.bucket[i].url]
  description = "The full URL to access the Google Cloud Storage bucket."
}

output "bucket_encryption_keys" {
  value       = [for i in range(length(google_storage_bucket.bucket)) : google_storage_bucket.bucket[i].self_link]
  description = "The encryption keys used for encrypting data in the bucket."
}

output "bucket_self_links" {
  value       = [for i in range(length(google_storage_bucket.bucket)) : google_storage_bucket.bucket[i].self_link]
  description = "The self-link URI of the Google Cloud Storage bucket, used for API references."
}
