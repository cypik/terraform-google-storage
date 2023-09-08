output "id" {
  value       = join("", google_storage_bucket.bucket.*.id)
  description = "The URI of the created resource."
}

output "name" {
  value       = join("", google_storage_bucket.bucket.*.name)
  description = "GCS bucket name."
}

output "self_link" {
  value       = join("", google_storage_bucket.bucket.*.self_link)
  description = "URI of the GCS bucket."
}

output "url" {
  value       = join("", google_storage_bucket.bucket.*.url)
  description = "The base URL of the bucket, in the format gs://<bucket-name>"
}

output "bucket" {
  value       = one(google_storage_bucket.bucket)
  description = "All attributes of the created `google_storage_bucket` resource."
}
