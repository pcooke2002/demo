resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  alarm_name          = "LambdaErrorAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"

  alarm_actions = [var.topic_arn]

  dimensions = {
    FunctionName = "my_api_gw_function"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_create" {
  alarm_name          = "ItemCreatedAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ItemCreated"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [var.topic_arn]

  dimensions = {
    FunctionName = "my_api_gw_function"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_delete" {
  alarm_name          = "ItemDeletedAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ItemDeleted"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [var.topic_arn]

  dimensions = {
    FunctionName = "my_api_gw_function"
  }
}


