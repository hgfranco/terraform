data "aws_iam_policy_document" "ecr_pull" {
  statement {
    sid       = "ECRAuthentication"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "PullApplicationImage"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
    ]

    resources = [module.ecr.repository_arn]
  }
}

module "node_instance_role" {
  source = "../../modules/ec2_instance_role"

  name                = "${var.name}-nodes"
  policy_json         = data.aws_iam_policy_document.ecr_pull.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEBSCSIDriverPolicyV2"]
}
