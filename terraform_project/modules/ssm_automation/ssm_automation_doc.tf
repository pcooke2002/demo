resource "aws_ssm_document" "xacct_ssm_automation" {
  name          = "CrossAccountRoles_report"
  document_type = "Automation"

  content = <<DOC
{
  "schemaVersion": "0.3",
  "description": "Cross account role report. This automation document will list out all roles that allow cross account access.",
  "assumeRole": "${aws_iam_role.xacct_report_executor_role.arn}",
  "mainSteps": [
    {
      "name": "RunScript",
      "action": "aws:executeScript",
      "isEnd": true,
      "onCancel": "Abort",
      "onFailure": "Abort",
      "inputs": {
        "Runtime": "python3.11",
        "Handler": "script_handler",
        "Script": "import boto3\nimport json\ndef script_handler(event, context):\n    cross_account_roles = []\n    account_id = context.get('global:ACCOUNT_ID')\n    iam = boto3.client('iam')\n    roles = iam.list_roles()\n    for role in roles['Roles']:\n        role_detail = iam.get_role(RoleName=role['RoleName'])\n        trust_policy = role_detail['Role']['AssumeRolePolicyDocument']\n        for statement in trust_policy['Statement']:\n            if 'AWS' in statement['Principal']:\n                principal_account_id = statement['Principal']['AWS'].split(':')[4]\n                if principal_account_id != account_id:\n                    cross_account_roles.append(role['Arn'])\n    print('Cross Account Roles:', cross_account_roles)\n    return {'status': 'success', 'cross_account_roles': cross_account_roles}"
      }
    }
  ]
}
DOC
}

resource "aws_iam_role" "xacct_report_executor_role" {
  name = "xacct_automation_report_executor"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ssm.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "xacct_report_executor_role_policy" {
  role       = aws_iam_role.xacct_report_executor_role.name
  policy_arn = aws_iam_policy.cross_account_automation_role_policy.arn
}


resource "aws_iam_policy" "cross_account_automation_role_policy" {
  name        = "xaccount_report_automation_policy"
  description = "Cross account role report automation policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "iam:GetRole",
          "iam:ListRoles",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups",
          "logs:CreateLogStream",
          "logs:CreateLogGroup"
        ],
        Resource = "*"
      }
    ]
  })
}

