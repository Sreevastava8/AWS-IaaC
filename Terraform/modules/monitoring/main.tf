resource "aws_sns_topic" "alerts" {
  name = "${var.environment}-shopsphere-alerts"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-shopsphere-alerts"
    }
  )
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

resource "aws_cloudwatch_metric_alarm" "application_errors" {
  alarm_name          = "${var.environment}-application-errors"
  namespace           = var.error_metric_namespace
  metric_name         = var.error_metric_name
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
  alarm_description   = "ShopSphere application errors detected in CloudWatch logs"
  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  tags = var.common_tags
}