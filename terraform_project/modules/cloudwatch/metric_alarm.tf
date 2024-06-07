resource "aws_cloudwatch_metric_alarm" "alarm_create" {
  alarm_name          = "ItemCreatedAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ItemCreated"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [aws_sns_topic.sns.arn]

  dimensions = {
    FunctionName = var.lambda_function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_delete" {
  alarm_name          = "ItemDeletedAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ItemDeleted"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [aws_sns_topic.sns.arn]

  dimensions = {
    FunctionName = var.lambda_function_name
  }
}

resource "aws_sns_topic" "sns" {
  name = "my-topic"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = var.email_subscriber
}

