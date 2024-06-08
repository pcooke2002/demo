resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/my_api_gw_function"
  retention_in_days = 1
}

#resource "aws_cloudwatch_log_group" "api_gateway_logs" {
#  name              = "MyApiGatewayLogs"
#  retention_in_days = 1
#}
