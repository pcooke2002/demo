resource "aws_ssm_document" "example" {
  name          = "CrossAccountRoles"
  document_type = "Automation"

  content = <<DOC
{
  "schemaVersion": "0.3",
  "description": "Cross account role report. This automation document will list out all roles that allow cross account access.",
  "assumeRole": "arn:aws:iam::033680424751:role/automation_executor",
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
        "Script": "import boto3\nimport json\ndef send_email(subject, body, recipient):\n    ses = boto3.client('ses')\n    ses.send_email(\n        Source='pcooke2002@snow.ninja',\n        Destination={'ToAddresses': [recipient]},\n        Message={\n            'Subject': {'Data': subject},\n            'Body': { 'Text': { 'Data': body}}\n        }\n    )\ndef script_handler(event, context):\n    cross_account_roles = []\n    account_id = context.get('global:ACCOUNT_ID')\n    iam = boto3.client('iam')\n    roles = iam.list_roles()\n    for role in roles['Roles']:\n        role_detail = iam.get_role(RoleName=role['RoleName'])\n        trust_policy = role_detail['Role']['AssumeRolePolicyDocument']\n        for statement in trust_policy['Statement']:\n            if 'AWS' in statement['Principal']:\n                principal_account_id = statement['Principal']['AWS'].split(':')[4]\n                if principal_account_id != account_id:\n                    cross_account_roles.append(role['Arn'])\n    return {'status': 'success', 'cross_account_roles': cross_account_roles}"
      }
    }
  ]
}
DOC
}

resource "aws_iam_role" "automation_executor" {
  name = "automation_executor"
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

resource "aws_iam_role_policy_attachment" "automation_executor_policy" {
  role       = aws_iam_role.automation_executor.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


resource "aws_iam_role" "test_cross_acct_role" {
  name = "test_cross_acct_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          AWS = "arn:aws:iam::767398046073:root"
        },
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy" "test_cross_acct_role_policy" {
  name = "test_cross_acct_role_policy"
  role = aws_iam_role.test_cross_acct_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "s3:ListBucket",
        Resource = "*",
        Effect = "Allow"
      }
    ]
  })
}