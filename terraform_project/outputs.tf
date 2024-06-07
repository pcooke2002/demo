output "api_gateway_url_default" {
  value = module.apigateway.url_default
}

output "api_gateway_url_poc" {
  value = module.apigateway.url_poc
}

output "lambda_function_invoke_arn" {
  value = module.lambda.function_invoke_arn
}