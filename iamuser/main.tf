resource "aws_iam_user" "pjruser" {
  name = "pjr-DevOps"

  tags = {
    JobTitle = "DevOps-Engineer"
  }
}

resource "aws_iam_user_login_profile" "pjruser_login" {
  user = aws_iam_user.pjruser.name
  password_reset_required = true
}

resource "aws_iam_user_policy_attachment" "Pjrreadonly" {
  user = aws_iam_user.pjruser.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_user_policy_attachment" "pjrchange_password" {
  user = aws_iam_user.pjruser.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_user_policy_attachment" "ec2-access" {
  user = aws_iam_user.pjruser.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
