resource "aws_api_gateway_rest_api" "my_api" {
  name        = "my_api"
  description = "API Gateway for my API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_request_validator" "default" {
  name                        = "default"
  rest_api_id                 = aws_api_gateway_rest_api.my_api.id
  validate_request_body       = true
  validate_request_parameters = true
}

resource "aws_api_gateway_resource" "items" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "items"
}

resource "aws_api_gateway_method" "items_post" {
  rest_api_id          = aws_api_gateway_rest_api.my_api.id
  resource_id          = aws_api_gateway_resource.items.id
  http_method          = "POST"
  authorization        = "NONE"
  api_key_required     = true
  request_validator_id = aws_api_gateway_request_validator.default.id
}

resource "aws_api_gateway_method" "items_get" {
  rest_api_id          = aws_api_gateway_rest_api.my_api.id
  resource_id          = aws_api_gateway_resource.items.id
  http_method          = "GET"
  authorization        = "NONE"
  api_key_required     = true
  request_validator_id = aws_api_gateway_request_validator.default.id
}

resource "aws_api_gateway_method" "items_put" {
  rest_api_id          = aws_api_gateway_rest_api.my_api.id
  resource_id          = aws_api_gateway_resource.items.id
  http_method          = "PUT"
  authorization        = "NONE"
  api_key_required     = true
  request_validator_id = aws_api_gateway_request_validator.default.id
}

resource "aws_api_gateway_method" "items_delete" {
  rest_api_id          = aws_api_gateway_rest_api.my_api.id
  resource_id          = aws_api_gateway_resource.items.id
  http_method          = "DELETE"
  authorization        = "NONE"
  api_key_required     = true
  request_validator_id = aws_api_gateway_request_validator.default.id
}

resource "aws_api_gateway_method" "items_options" {
  rest_api_id          = aws_api_gateway_rest_api.my_api.id
  resource_id          = aws_api_gateway_resource.items.id
  http_method          = "OPTIONS"
  authorization        = "NONE"
  api_key_required     = true
  request_validator_id = aws_api_gateway_request_validator.default.id
}

resource "aws_api_gateway_integration" "lambda_post" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.items.id
  http_method             = aws_api_gateway_method.items_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.function_invoke_arn
}

resource "aws_api_gateway_integration" "lambda_get" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.items.id
  http_method             = aws_api_gateway_method.items_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.function_invoke_arn
}

resource "aws_api_gateway_integration" "lambda_put" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.items.id
  http_method             = aws_api_gateway_method.items_put.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.function_invoke_arn
}

resource "aws_api_gateway_integration" "lambda_delete" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.items.id
  http_method             = aws_api_gateway_method.items_delete.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.function_invoke_arn
}

resource "aws_api_gateway_integration" "lambda_options" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.items.id
  http_method             = aws_api_gateway_method.items_options.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.function_invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_post,
    aws_api_gateway_integration.lambda_get,
    aws_api_gateway_integration.lambda_put,
    aws_api_gateway_integration.lambda_delete,
    aws_api_gateway_integration.lambda_options
  ]

  rest_api_id = aws_api_gateway_rest_api.my_api.id
  #  stage_name  = "v1"
}

resource "aws_api_gateway_usage_plan" "usage_plan" {
  name = "my_api_usage_plan"
  api_stages {
    api_id = aws_api_gateway_rest_api.my_api.id
    stage  = aws_api_gateway_stage.default.stage_name
  }

  api_stages {
    api_id = aws_api_gateway_rest_api.my_api.id
    stage  = aws_api_gateway_stage.poc.stage_name
  }

  throttle_settings {
    burst_limit = 100
    rate_limit  = 100
  }

  quota_settings {
    limit  = 100000
    period = "DAY"
  }
}

resource "aws_api_gateway_api_key" "api_key" {
  name        = "my_api_key"
  description = "API key for my API Gateway"
  enabled     = true
  value       = var.api_key
}

resource "aws_api_gateway_usage_plan_key" "usage_plan_key" {
  key_id        = aws_api_gateway_api_key.api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plan.id
}

resource "aws_api_gateway_documentation_part" "my_doc" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id

  location {
    type = "API"
    #    method = "POST"
    #    path   = "/items"
  }
  properties = jsonencode({
    description = "API Documentation for my_api"
  })
}



resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name              = "${aws_api_gateway_rest_api.my_api.name}-logs"
  retention_in_days = 1
}

resource "aws_api_gateway_stage" "default" {
  rest_api_id          = aws_api_gateway_rest_api.my_api.id
  stage_name           = var.stage_default
  deployment_id        = aws_api_gateway_deployment.api_deployment.id
  xray_tracing_enabled = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_logs.arn
    format = jsonencode({
      requestId : "$context.requestId",
      ip : "$context.identity.sourceIp",
      caller : "$context.identity.caller",
      user : "$context.identity.user",
      requestTime : "$context.requestTime",
      httpMethod : "$context.httpMethod",
      resourcePath : "$context.resourcePath",
      status : "$context.status",
      protocol : "$context.protocol",
      responseLength : "$context.responseLength"
    })
  }
}


resource "aws_api_gateway_method_settings" "default" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = aws_api_gateway_stage.default.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled    = true
    logging_level      = "INFO"
    data_trace_enabled = true
  }
}

resource "aws_api_gateway_stage" "poc" {
  rest_api_id          = aws_api_gateway_rest_api.my_api.id
  stage_name           = var.stage_poc
  deployment_id        = aws_api_gateway_deployment.api_deployment.id
  xray_tracing_enabled = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_logs.arn
    format = jsonencode({
      requestId : "$context.requestId",
      ip : "$context.identity.sourceIp",
      caller : "$context.identity.caller",
      user : "$context.identity.user",
      requestTime : "$context.requestTime",
      httpMethod : "$context.httpMethod",
      resourcePath : "$context.resourcePath",
      status : "$context.status",
      protocol : "$context.protocol",
      responseLength : "$context.responseLength"
    })
  }
}

resource "aws_api_gateway_method_settings" "poc" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = aws_api_gateway_stage.poc.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled    = true
    logging_level      = "INFO"
    data_trace_enabled = true
  }
}

data "aws_iam_policy_document" "api_gateway_invoke_lambda" {
  statement {
    actions   = ["lambda:InvokeFunction"]
#    resources = [aws_lambda_function.my_api_gw_function.arn]
    resources = [var.function_invoke_arn]
  }
}

resource "aws_iam_policy" "api_gateway_invoke_lambda" {
  name        = "api_gateway_invoke_lambda"
  description = "Allows API Gateway to invoke the Lambda function"
  policy      = data.aws_iam_policy_document.api_gateway_invoke_lambda.json
}

resource "aws_iam_role" "api_gateway_role" {
  name = "api_gateway_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
        Effect = "Allow"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "api_gateway_invoke_lambda" {
  role       = aws_iam_role.api_gateway_role.name
  policy_arn = aws_iam_policy.api_gateway_invoke_lambda.arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/*"
}

resource "aws_api_gateway_documentation_part" "post_doc" {
  location {
    type   = "METHOD"
    method = "POST"
    path   = "/items"
  }
  properties = "{\"description\":\"POST method documentation\"}"
  rest_api_id = aws_api_gateway_rest_api.my_api.id
}

resource "aws_api_gateway_documentation_part" "get_doc" {
  location {
    type   = "METHOD"
    method = "GET"
    path   = "/items"
  }
  properties = "{\"description\":\"GET method documentation\"}"
  rest_api_id = aws_api_gateway_rest_api.my_api.id
}

resource "aws_api_gateway_documentation_part" "put_doc" {
  location {
    type   = "METHOD"
    method = "PUT"
    path   = "/items"
  }
  properties = "{\"description\":\"PUT method documentation\"}"
  rest_api_id = aws_api_gateway_rest_api.my_api.id
}

resource "aws_api_gateway_documentation_part" "delete_doc" {
  location {
    type   = "METHOD"
    method = "DELETE"
    path   = "/items"
  }
  properties = "{\"description\":\"DELETE method documentation\"}"
  rest_api_id = aws_api_gateway_rest_api.my_api.id
}

resource "aws_api_gateway_documentation_part" "options_doc" {
  location {
    type   = "METHOD"
    method = "OPTIONS"
    path   = "/items"
  }
  properties = "{\"description\":\"OPTIONS method documentation\"}"
  rest_api_id = aws_api_gateway_rest_api.my_api.id
}