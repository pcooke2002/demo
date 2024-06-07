data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_function"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "my_api_gw_function" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "my_api_gw_function"
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "python3.12"
  role             = var.lambda_role
  environment {
    variables = {
      TABLE_NAME = var.table_name
    }
  }
  layers = [var.layer_arn]
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_api_gw_function.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = var.api_gateway_arn
}
