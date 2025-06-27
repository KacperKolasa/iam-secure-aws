# outputs.tf  (root module)

output "mfa_policy_arn" {
  description = "Deny-unless-MFA policy ARN (from iam module)"
  value       = module.iam.mfa_enforce_policy_arn
}

output "cloudtrail_trail" {
  description = "CloudTrail trail name (from audit module)"
  value       = module.audit.cloudtrail_name
}

output "cloudtrail_bucket" {
  description = "S3 bucket that stores CloudTrail logs"
  value       = module.audit.log_bucket
}
