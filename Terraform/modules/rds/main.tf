resource "aws_db_subnet_group" "shopsphere" {
  name = "${var.environment}-shopsphere-db"

  subnet_ids = var.db_subnet_ids

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-shopsphere-db"
    }
  )
}

resource "aws_security_group" "rds" {
  name        = "${var.environment}-rds"
  description = "Security group for ShopSphere PostgreSQL RDS"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-rds"
    }
  )
}

resource "aws_db_instance" "postgres" {
  identifier = var.instance_name

  engine         = "postgres"
  engine_version = var.database_version

  instance_class = var.instance_class

  allocated_storage = var.allocated_storage
  storage_type      = "gp3"

  db_name                     = var.database_name
  username                    = var.username
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.shopsphere.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = false

  multi_az                = var.multi_az
  backup_retention_period = 7
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-rds"
    }
  )
}