resource "aws_s3_bucket" "shopsphere" {
  bucket = var.bucket_name

  tags = merge(
    var.common_tags,
    {
      Name = var.bucket_name
    }
  )
}

resource "aws_s3_bucket_versioning" "shopsphere" {
  bucket = aws_s3_bucket.shopsphere.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "shopsphere" {
  bucket = aws_s3_bucket.shopsphere.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "shopsphere" {
  bucket = aws_s3_bucket.shopsphere.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "shopsphere" {
  bucket = aws_s3_bucket.shopsphere.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "shopsphere" {
  bucket = aws_s3_bucket.shopsphere.id

  rule {
    id     = "delete-after-45-days"
    status = "Enabled"

    expiration {
      days = 45
    }
  }
}

