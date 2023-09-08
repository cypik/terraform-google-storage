output "id" {
  value       = module.bucket.id
  description = "The ID of the s3 bucket."
}

output "self_link" {
  value       = module.bucket.self_link
  description = "URI of the GCS bucket."
}

output "url" {
  value       = module.bucket.url
  description = "The base URL of the bucket, in the format gs://<bucket-name>"
}

output "bucket" {
  value       = module.bucket.bucket
  description = "All attributes of the created `google_storage_bucket` resource."
}