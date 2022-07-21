output "source_s3_bucket_id" {
  description = "The name of the bucket."
  value       = try(aws_s3_bucket_policy.bucket_policy.id, aws_s3_bucket.source-bucket[0].id, "")
}

output "source_s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = try(aws_s3_bucket.source-bucket[0].arn, "")
}

output "source_s3_bucket_name" {
  description = "The name of the bucket."
  value       = try(aws_s3_bucket.source-bucket[0].bucket, "")
}


output "destination_s3_bucket_id" {
  description = "The name of the bucket."
  value       = try(aws_s3_bucket_policy.destination_bucket_policy.id, aws_s3_bucket.destination-bucket[0].id, "")
}

output "destination_s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = try(aws_s3_bucket.destination-bucket[0].arn, "")
}