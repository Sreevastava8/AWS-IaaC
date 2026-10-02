output "sns_topic_arn" {
  description = "SNS topic ARN used for monitoring alerts"
  value       = aws_sns_topic.alerts.arn
}

output "sns_topic_name" {
  description = "SNS topic name used for monitoring alerts"
  value       = aws_sns_topic.alerts.name
}

output "email_subscription_arn" {
  description = "SNS email subscription ARN"
  value       = aws_sns_topic_subscription.email.arn
}

output "application_error_alarm_arn" {
  description = "CloudWatch application error alarm ARN"
  value       = aws_cloudwatch_metric_alarm.application_errors.arn
}

output "application_error_alarm_name" {
  description = "CloudWatch application error alarm name"
  value       = aws_cloudwatch_metric_alarm.application_errors.alarm_name
}