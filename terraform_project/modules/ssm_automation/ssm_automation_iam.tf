data "aws_caller_identity" "current" {}

resource "aws_iam_role" "cloud_ops_role" {
  name = "cloud-ops-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          AWS = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/admin1"]
        },
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_policy" "cloud_ops_policy" {
  name        = "cloud_ops_policy"
  description = "Policy for cloud_ops_role"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:List*",
          "ssm:Describe*",
          "ssm:Get*",
          "ssm:StartAutomationExecution",
          "ssm:StopAutomationExecution",
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DescribeAlarms",
          "iam:GetRole",

        ],
        Resource = "*"
      },
      {
        Effect   = "Deny",
        Action   = "iam:PassRole",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloud_ops_policy_attachment" {
  depends_on = [aws_iam_policy.cloud_ops_policy, aws_iam_role.cloud_ops_role]
  role       = aws_iam_role.cloud_ops_role.name
  policy_arn = aws_iam_policy.cloud_ops_policy.arn
}

variable "xacct_report_other_acct" {
#   default   = "767398046073"
  sensitive = true
  type      = string
}

resource "aws_iam_role" "xacct_fake_test_role" {
  name = "xacct-fake-test-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          AWS = ["arn:aws:iam::${var.xacct_report_other_acct}:role/fake_role"]
        },
        Effect = "Allow"
      }
    ]
  })
}