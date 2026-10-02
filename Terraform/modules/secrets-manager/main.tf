
resource "aws_secretsmanager_secret" "jwt" {
  name = "${var.environment}/shopsphere/jwt-secret"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}/shopsphere/jwt-secret"
    }
  )
}

resource "aws_secretsmanager_secret_version" "jwt" {
  secret_id                = aws_secretsmanager_secret.jwt.id
  secret_string_wo         = var.jwt_secret
  secret_string_wo_version = 1
}