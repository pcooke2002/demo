# variable "arg_map" {
#   type = map(list(string))
#   default = {
#     "key1" = ["a", "b"]
#     "key2" = ["d", "e"]
#     "key3" = ["g", "h"]
#     "key4" = ["j", "k"]
#   }
# }
#
# data "aws_caller_identity" "current" {}
#
# resource "aws_ssm_document" "looping_template_document" {
#   name          = "looping_template_SSM_automation"
#   document_type = "Automation"
#
#   content = templatefile("${path.module}/looping_template.tftpl", {
#     arg_map = var.arg_map
#     account_number = data.aws_caller_identity.current.account_id
#   })
# }
#
#
#
# resource "aws_lambda_function" "looping_template_lambda" {
#   function_name = "looping_template_lambda"
#   handler       = "echo_lambda.lambda_handler"
#   runtime       = "python3.12"
#   role          = aws_iam_role.lambda_role.arn
#   filename      = "${path.module}/ssm_automation/lambda_function.zip"
# }
#
# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_dir  = "${path.module}/lambda_function"
#   output_path = "${path.module}/lambda_function.zip"
# }
#
#
#
# resource "aws_iam_role" "lambda_role" {
#   name = "lambda_role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         },
#         Effect = "Allow",
#       },
#     ],
#   })
# }