# iam/outputs.tf
output "mfa_enforce_policy_arn" {
  description = "ARN of the deny-unless-MFA policy"
  value       = aws_iam_policy.enforce_mfa.arn
}

# (OPTIONAL) If you really want a list of user names,
# first declare your users with for_each in users.tf:
#
# resource "aws_iam_user" "user" {
#   for_each = toset(["alice", "bob"])
#   name          = each.key
#   force_destroy = true
# }
#
# …then you can safely output:
# output "user_names"  { value = keys(aws_iam_user.user) }
#
# If you kept individual resources (aws_iam_user.alice, etc.)
# just skip the list-of-users output for now.
