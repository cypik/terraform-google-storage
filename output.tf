output "bucket_info" {
  value       = google_storage_bucket.bucket[*]
  description = "List of GCS buckets with their details."
}

output "bucket_id" {
  value       = join("", google_storage_bucket.bucket[*].id)
  description = "List of GCS bucket IDs."
}

output "bucket_name" {
  value       = join("", google_storage_bucket.bucket[*].name)
  description = "List of GCS bucket names."
}

output "bucket_self_links" {
  value       = join("", google_storage_bucket.bucket[*].self_link)
  description = "List of URIs for GCS buckets."
}

output "bucket_urls" {
  value       = join("", google_storage_bucket.bucket[*].url)
  description = "List of base URLs for GCS buckets, in the format gs://<bucket-name>"
}
