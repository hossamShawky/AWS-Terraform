# Creating S3 bucket for web hosting  

resource "aws_s3_bucket" "file_uploader_app_bucket" {
  bucket        = var.web_bucket
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  tags = {
    Name = "File Uploader Service App Bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "file_uploader_app_bucket_owner" {
  bucket = aws_s3_bucket.file_uploader_app_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "file_uploader_app_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.file_uploader_app_bucket_owner]
  bucket     = aws_s3_bucket.file_uploader_app_bucket.id
  acl        = "public-read"
}