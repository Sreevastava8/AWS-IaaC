output "bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.shopsphere.bucket
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.shopsphere.arn
}

output "bucket_url" {
  description = "S3 bucket regional URL"
  value       = aws_s3_bucket.shopsphere.bucket_regional_domain_name
}