output "log_group_name" {
  description = "CloudWatch Log Group name"
  value       = aws_cloudwatch_log_group.application.name
}

output "log_group_arn" {
  description = "CloudWatch Log Group ARN"
  value       = aws_cloudwatch_log_group.application.arn
}

output "error_metric_name" {
  description = "CloudWatch application error metric name"
  value       = var.error_metric_name
}

output "error_metric_namespace" {
  description = "CloudWatch application error metric namespace"
  value       = "ShopSphere/Application"
}