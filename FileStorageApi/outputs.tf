output "user_content_bucket" {
  value = aws_s3_bucket.user_content_bucket.bucket
}

output "api_gateway_url" {
  value = "${aws_api_gateway_deployment.FileUploderService.invoke_url}upload/"
}