## Creates the S3 bucket ##
resource "aws_s3_bucket" "upload" {
  bucket = "${var.namespace}-${var.bucket_name}"
}

