# iam/outputs.tf
output "mfa_enforce_policy_arn" {
  description = "ARN of the deny-unless-MFA policy"
  value       = aws_iam_policy.enforce_mfa.arn
}