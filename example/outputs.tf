output "bucket_id" {
  value       = module.bucket.bucket_id
  description = "The ID of the GCP  bucket_id"
}

output "bucket_self_links" {
  value       = module.bucket.bucket_self_links
  description = "URI of the GCP bucket."
}

output "bucket_urls" {
  value       = module.bucket.bucket_urls
  description = "The base URL of the bucket, in the format gs://<bucket-name>"
}

output "bucket_name" {
  value       = module.bucket.bucket_name
  description = "All attributes of the created `google_storage_bucket` resource."
}