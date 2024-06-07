variable "topic_arn" {
  description = "SNS topic ARN"
  type        = string
}

variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
  default     = "my_api_gw_function"
}

variable "email_subscriber" {
  description = "Email subscriber for SNS topic"
  type        = string
  default     = "pcooke2002@yahoo.com"
}