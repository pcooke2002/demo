resource "aws_sns_topic" "my_topic" {
  name = "my-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  count                  = var.email_subscriber != null ? 1 : 0
  topic_arn              = aws_sns_topic.my_topic.arn
  endpoint_auto_confirms = true
  protocol               = "email"
  endpoint               = var.email_subscriber
}
