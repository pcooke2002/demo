resource "aws_iam_role" "lambda_role" {
  name = "MyLambdaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name = "lambda-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "dynamodb:*",
            "logs:*",
            "xray:*",
            "cloudwatch:PutMetricData"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}
