# audit/outputs.tf
output "cloudtrail_name" {
  value = aws_cloudtrail.main.name
}

output "log_bucket" {
  value = aws_s3_bucket.ct_logs.id
}
