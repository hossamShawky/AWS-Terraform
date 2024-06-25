output "sns" {
  value = module.SNS.sns_name
}

output "MainS3" {
  value = module.MainS3.bucket_name
}

output "Resized3" {
  value = module.Resized3.bucket_name
}