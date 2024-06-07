output "api_gateway_arn" {
  value = aws_api_gateway_rest_api.my_api.execution_arn
}

output "url_default" {
  value = aws_api_gateway_stage.default.invoke_url
}

output "url_poc" {
  value = aws_api_gateway_stage.poc.invoke_url
}


