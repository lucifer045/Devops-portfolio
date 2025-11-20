resource "aws_s3_bucket" "bucky" {
  bucket = var.bucket_name

  tags = {
    Name = "${var.env}-bucket"
  }
}

resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.bucky.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
    bucket = aws_s3_bucket.bucky.id
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
}

resource "aws_s3_bucket_public_access_block" "state_block" {
    bucket = aws_s3_bucket.bucky.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}