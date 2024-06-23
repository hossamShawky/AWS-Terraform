# Creating S3 bucket for web hosting  

resource "aws_s3_bucket" "file_uploader_app_bucket" {
  bucket        = var.web_bucket
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  tags = {
    Name = "File-Uploader-Service-App-Bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "s3-public-access" {
  bucket = aws_s3_bucket.file_uploader_app_bucket.bucket

  block_public_acls = true
  depends_on        = [aws_s3_bucket.file_uploader_app_bucket]

}

resource "aws_s3_bucket_policy" "s3-policy" {
  bucket = aws_s3_bucket.file_uploader_app_bucket.bucket

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.file_uploader_app_bucket.bucket}/*"
    }
  ]
}
EOF

  depends_on = [aws_s3_bucket_public_access_block.s3-public-access]
}