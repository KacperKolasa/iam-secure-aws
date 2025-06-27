data "aws_iam_policy_document" "enforce_mfa" {
  statement {
    sid        = "DenyAllExceptListedIfNoMFA"
    effect     = "Deny"
    not_actions = [
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:GetUser",
      "iam:ListMFADevices",
      "iam:ListVirtualMFADevices",
      "iam:ResyncMFADevice",
      "sts:GetSessionToken"
    ]
    resources = ["*"]
    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["false"]
    }
  }
}

resource "aws_iam_policy" "enforce_mfa" {
  name        = "EnforceMFA"
  description = "Deny all actions if MFA not present"
  policy      = data.aws_iam_policy_document.enforce_mfa.json
}

resource "aws_iam_group_policy_attachment" "mfa_all_devs" {
  for_each  = toset([
    aws_iam_group.developers.name,
    aws_iam_group.operations.name,
    aws_iam_group.finance.name,
    aws_iam_group.security.name,
  ])
  group      = each.value
  policy_arn = aws_iam_policy.enforce_mfa.arn
}
