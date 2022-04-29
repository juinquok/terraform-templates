## Creates KMS key for S3 ##
resource "aws_kms_key" "s3_upload" {
  description             = "S3 Key"
  deletion_window_in_days = 7
  enable_key_rotation = true
}

## Creates the S3 bucket ##
resource "aws_s3_bucket" "upload" {
  bucket = "${var.namespace}-${var.bucket_name}"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "upload" {
  bucket = aws_s3_bucket.upload.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_upload.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "upload" {
  bucket = aws_s3_bucket.upload.id
  versioning_configuration {
    status = "Enabled"
  }
}

## Enforces private bucket ##
resource "aws_s3_bucket_public_access_block" "upload" {
  bucket = aws_s3_bucket.upload.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

## Controls S3 bucket ownership ##
resource "aws_s3_bucket_ownership_controls" "upload" {
  bucket = aws_s3_bucket.upload.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

## Sets S3 ACL ##
resource "aws_s3_bucket_acl" "upload" {
  bucket = aws_s3_bucket.upload.id
  acl    = "private"
}