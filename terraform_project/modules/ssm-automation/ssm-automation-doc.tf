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
        "Script": "import boto3\nimport json\nimport pprint\ndef script_handler(event, context):\n    print('context=', context)\n    account_id = context.get('global:ACCOUNT_ID')\n    iam = boto3.client('iam')\n    roles = iam.list_roles()\n    pprint.pprint( roles)\n    return {'status': 'success'}"
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
