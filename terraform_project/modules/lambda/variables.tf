variable "lambda_role" {
  description = "IAM role for Lambda function"
  type        = string
}

variable "table_name" {
  description = "DynamoDB table name"
  type        = string
}

variable "layer_arn" {
  description = "ARN of the Lambda layer"
  type        = string
}

variable "api_gateway_arn" {
  description = "ARN of the API Gateway"
  type        = string
}
