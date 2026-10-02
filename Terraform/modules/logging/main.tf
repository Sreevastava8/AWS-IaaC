locals {
  log_group_name = var.log_group_name != "" ? var.log_group_name : "/shopsphere/${var.environment}/application"
}


resource "aws_cloudwatch_log_group" "application" {
  name              = local.log_group_name
  retention_in_days = var.log_retention_days

  tags = merge(
    var.common_tags,
    {
      Name = local.log_group_name
    }
  )
}


resource "aws_cloudwatch_log_metric_filter" "application_errors" {
  name           = "${var.environment}-application-errors"
  log_group_name = aws_cloudwatch_log_group.application.name
  pattern        = "?ERROR ?Error ?error"

  metric_transformation {
    name      = var.error_metric_name
    namespace = "ShopSphere/Application"
    value     = "1"
  }
}