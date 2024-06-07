output "lambda_arn" {
  value = aws_lambda_function.my_api_gw_function.arn
}

output "function_invoke_arn" {
  description = "The ARN to be used for invoking the Lambda function from API Gateway"
  value       = aws_lambda_function.my_api_gw_function.invoke_arn
}

output "function_name" {
  value = aws_lambda_function.my_api_gw_function.function_name
}