output "upload_bucket_id" {
  description = "Bucket Name for Uploaded Content"
  value       = aws_s3_bucket.upload.id
}

output "upload_bucket_arn" {
  description = "Bucket ARN for Uploaded Content"
  value = aws_s3_bucket.upload.arn
}