variable "lambda_arn" {
  description = "ARN of the Lambda function"
  type        = string
}

variable "api_key" {
  description = "API key for API Gateway"
  type        = string
}

variable "stage_default" {
  description = "Default stage name for API Gateway"
  type        = string
  default     = "default"
}

variable "stage_poc" {
  description = "POC stage name for API Gateway"
  type        = string
  default     = "poc"
}

variable "function_invoke_arn" {
  description = "Production stage name for API Gateway"
  type        = string
}

variable "function_name" {
  description = "the name of the lambda function"
  type        = string
}
