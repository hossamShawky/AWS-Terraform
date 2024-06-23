#-1 Create S3 To Store Files From API
resource "aws_s3_bucket" "user_content_bucket" {
  bucket = var.user_bucket
  lifecycle {
    prevent_destroy = false #var.destroy
  }

  force_destroy = true
  tags = {
    "Name" = "${var.user_bucket}"
  }
}


resource "aws_s3_bucket_versioning" "bucket_version" {
  bucket = aws_s3_bucket.user_content_bucket.bucket
  versioning_configuration {
    status = "Disabled"
  }

}

