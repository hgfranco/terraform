resource "aws_iam_role" "create_role" {
  name               = var.iam_role_name
  description        = var.iam_role_description
  assume_role_policy = file(var.iam_role_assume_role_policy_path)
}

resource "aws_iam_role_policy_attachment" "create_attachment" {
  role       = aws_iam_role.create_role.name
  policy_arn = var.iam_role_policy_arn
}
