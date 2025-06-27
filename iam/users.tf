resource "aws_iam_user" "alice" {
  name          = "alice"
  force_destroy = true            # allow automatic cleanup
}

resource "aws_iam_user_group_membership" "alice_groups" {
  user   = aws_iam_user.alice.name
  groups = [aws_iam_group.developers.name]
}

resource "aws_iam_user_login_profile" "alice_console_pwd" {
  user                    = aws_iam_user.alice.name
  password_length         = 16
  password_reset_required = true   # forces her to pick a secret after first login
}
