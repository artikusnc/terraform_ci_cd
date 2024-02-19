# S3 Bucket for TF State File
resource "aws_s3_bucket" "sergio_bucket" {
  bucket = "my-tf-test-bucketsergio"
}

resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
  bucket = aws_s3_bucket.sergio_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_crypto_conf" {
  bucket = aws_s3_bucket.sergio_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Dynamo DB Table for Locking TF Config
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "sergio_bucket-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}


