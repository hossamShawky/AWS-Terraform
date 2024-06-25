#Create S3 Bucket
resource "random_string" "unique_id" {
  length  = 5
  special = false
  upper   = false
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${random_string.unique_id.result}-${var.type}"
  lifecycle {
    prevent_destroy = false
  }

  force_destroy = true
}