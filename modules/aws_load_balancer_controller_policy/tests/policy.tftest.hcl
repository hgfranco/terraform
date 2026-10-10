mock_provider "aws" {}

variables {
  name    = "test-controller"
  vpc_arn = "arn:aws:ec2:us-east-1:123456789012:vpc/vpc-0123456789abcdef0"
}

run "security_group_ingress_requires_vpc_or_existing_ownership_condition" {
  command = plan

  assert {
    condition = alltrue([
      for statement in jsondecode(aws_iam_policy.this.policy).Statement :
      can(statement.Condition)
      if contains(statement.Action, "ec2:AuthorizeSecurityGroupIngress") ||
      contains(statement.Action, "ec2:RevokeSecurityGroupIngress")
    ])
    error_message = "Security-group ingress mutations must not have unconditional permissions."
  }

  assert {
    condition = length([
      for statement in jsondecode(aws_iam_policy.this.policy).Statement : statement
      if try(statement.Condition.ArnEquals["ec2:Vpc"], "") == var.vpc_arn &&
      contains(statement.Action, "ec2:AuthorizeSecurityGroupIngress") &&
      contains(statement.Action, "ec2:RevokeSecurityGroupIngress")
    ]) == 1
    error_message = "Ingress management must be scoped to the supplied cluster VPC."
  }

  assert {
    condition = anytrue([
      for statement in jsondecode(aws_iam_policy.this.policy).Statement :
      contains(statement.Action, "elasticloadbalancing:CreateLoadBalancer") &&
      try(statement.Condition.Null["aws:RequestTag/elbv2.k8s.aws/cluster"], "") == "false"
    ])
    error_message = "Load-balancer creation must retain its upstream ownership-tag requirement."
  }
}
