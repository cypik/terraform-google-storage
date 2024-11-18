output "hmac_keys" {
  value       = google_storage_hmac_key.hmac_keys[*]
  sensitive   = true
  description = "List of HMAC keys."
}

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