resource "aws_s3_bucket" "tf_state_bucket" {
    bucket = "aws-tf-state-us-west-1"
    force_destroy = true
    tags = {
        Name = "terraform state bucket"
        Env = "dev"
    }
}

resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.tf_state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
    bucket = aws_s3_bucket.tf_state_bucket.id
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
}

resource "aws_s3_bucket_public_access_block" "state_block" {
    bucket = aws_s3_bucket.tf_state_bucket.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

resource "aws_dynamodb_table" "tf_state_lock" {
    name = "terraform-state-lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }
    tags = {
        Name = "Terraform Lock Table"
        Env = "dev"
    }
} 