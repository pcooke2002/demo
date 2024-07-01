terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "lambda_layer" {
  source = "./modules/lambda_layer"
}

module "lambda_iam" {
  source = "./modules/lambda_iam"
}

module "sns" {
  source           = "./modules/sns"
  email_subscriber = var.email_subscriber
}

module "cloudwatch" {
  source    = "./modules/cloudwatch"
  topic_arn = module.sns.topic_arn
}

module "apigateway" {
  source              = "./modules/apigateway"
  lambda_arn          = module.lambda.lambda_arn
  api_key             = var.api_key
  stage_default       = "default"
  stage_poc           = var.stage_poc
  function_invoke_arn = module.lambda.function_invoke_arn
  function_name       = module.lambda.function_name
}

module "lambda" {
  source     = "./modules/lambda"
  layer_arn  = module.lambda_layer.layer_arn
  table_name = module.dynamodb.table_name
  #  topic_arn      = module.sns.topic_arn
  lambda_role     = module.lambda_iam.lambda_role_arn
  api_gateway_arn = module.apigateway.api_gateway_arn
}

module "ssm-automation" {
  source = "./modules/ssm-automation"
}