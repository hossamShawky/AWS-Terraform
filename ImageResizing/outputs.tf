output "sns_arn" {
  value = module.SNS.sns_arn
}

output "MainS3" {
  value = module.MainS3.bucket_name
}

output "ResizedS3" {
  value = module.Resized3.bucket_name
}