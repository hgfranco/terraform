resource "aws_iam_policy" "create_policy" {
  name        = var.iam_policy_name
  path        = var.iam_policy_path
  description = var.iam_policy_description
  policy      = file(var.iam_policy_file_path)
}
