output "buckets_id" {
  value       = module.cloud_storage.buckets_id
  description = "The ID of the GCP  bucket_id"
}

output "buckets_map" {
  value       = module.cloud_storage.buckets_map
  description = "Bucket resources by name."
}

output "buckets_self_links" {
  value       = module.cloud_storage.buckets_self_links
  description = "URI of the GCP bucket."
}

output "buckets_urls" {
  value       = module.cloud_storage.urls
  description = "The base URL of the bucket, in the format gs://<bucket-name>"
}

output "names" {
  description = "Bucket names."
  value       = module.cloud_storage.names
}

output "names_list" {
  description = "List of bucket names."
  value       = module.cloud_storage.names_list
}

output "hmac_keys" {
  description = "List of bucket names."
  value       = module.cloud_storage.hmac_keys
}

output "urls_list" {
  value       = module.cloud_storage.urls_list
  description = "List of bucket URLs."
}