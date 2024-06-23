output "user_content_bucket" {
  value = aws_s3_bucket.user_content_bucket.bucket
}

output "api_gateway_url" {
  value = "${aws_api_gateway_deployment.FileUploderService.invoke_url}upload/"
}

output "website" {
  value = "http://${aws_s3_bucket.file_uploader_app_bucket.website_endpoint}"

}