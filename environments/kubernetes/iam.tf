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

module "load_balancer_controller_policy" {
  source = "../../modules/aws_load_balancer_controller_policy"

  name    = "${var.name}-load-balancer-controller"
  vpc_arn = module.network.vpc_arn
}

resource "aws_iam_role_policy_attachment" "load_balancer_controller" {
  role       = module.node_instance_role.role_name
  policy_arn = module.load_balancer_controller_policy.policy_arn
}
