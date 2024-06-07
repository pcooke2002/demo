resource "aws_lambda_layer_version" "xray_sdk" {
  filename            = "${path.module}/xray-sdk.zip"
  layer_name          = "xray-sdk"
  compatible_runtimes = ["python3.12"]
}

