output "bucket_info" {
  value       = google_storage_bucket.bucket[*]
  description = "List of GCP buckets with their details."
}

output "bucket_id" {
  value       = join("", google_storage_bucket.bucket[*].id)
  description = "List of GCP bucket IDs."
}

output "bucket_name" {
  value       = join("", google_storage_bucket.bucket[*].name)
  description = "List of GCP bucket names."
}

output "bucket_self_links" {
  value       = join("", google_storage_bucket.bucket[*].self_link)
  description = " The URI of the created resource."
}

output "bucket_urls" {
  value       = join("", google_storage_bucket.bucket[*].url)
  description = "The base URL of the bucket, in the format gs://<bucket-name>."
}
