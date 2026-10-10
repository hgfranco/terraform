locals {
  # Vendored from the controller v3.6.0 release; do not fetch main at apply time.
  upstream_policy = jsondecode(file("${path.module}/iam_policy.json"))

  policy = merge(local.upstream_policy, {
    Statement = [
      for statement in local.upstream_policy.Statement : jsondecode(
        contains(statement.Action, "ec2:AuthorizeSecurityGroupIngress") && !contains(keys(statement), "Condition") ?
        jsonencode(merge(statement, {
          Sid = "ManageIngressInClusterVPC"
          Condition = {
            ArnEquals = {
              "ec2:Vpc" = var.vpc_arn
            }
          }
        })) :
        jsonencode(statement)
      )
    ]
  })
}

resource "aws_iam_policy" "this" {
  name        = var.name
  description = "AWS Load Balancer Controller v3.6.0 permissions; ingress management scoped to the cluster VPC."
  policy      = jsonencode(local.policy)
  tags        = var.tags
}
