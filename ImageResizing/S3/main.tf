#Create S3 Bucket

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.project}-${var.type}"
  lifecycle {
    prevent_destroy = false
  }

  force_destroy = true
}