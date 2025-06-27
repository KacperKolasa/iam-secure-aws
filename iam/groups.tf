locals {
  readonly_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]
}

resource "aws_iam_group" "developers"  { name = "Developers" }
resource "aws_iam_group" "operations"  { name = "Operations" }
resource "aws_iam_group" "finance"     { name = "Finance" }
resource "aws_iam_group" "security"    { name = "SecurityAuditors" }

data "aws_iam_policy" "readonly"   { arn = local.readonly_arns[0] }
data "aws_iam_policy" "poweruser"  { arn = "arn:aws:iam::aws:policy/PowerUserAccess" }

resource "aws_iam_group_policy_attachment" "dev_power" {
  group      = aws_iam_group.developers.name
  policy_arn = data.aws_iam_policy.poweruser.arn
}
resource "aws_iam_group_policy_attachment" "ops_power" {
  group      = aws_iam_group.operations.name
  policy_arn = data.aws_iam_policy.poweruser.arn
}
resource "aws_iam_group_policy_attachment" "fin_readonly" {
  group      = aws_iam_group.finance.name
  policy_arn = data.aws_iam_policy.readonly.arn
}
resource "aws_iam_group_policy_attachment" "sec_readonly" {
  group      = aws_iam_group.security.name
  policy_arn = data.aws_iam_policy.readonly.arn
}
