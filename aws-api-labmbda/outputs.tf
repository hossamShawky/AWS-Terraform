output "dynamodb_table_name" {
  value = aws_dynamodb_table.Dynamodb.name
}

output "lambda_function_name" {
  value = aws_lambda_function.my_lambda.function_name
}

output "api_gateway_url" {
  value = "${aws_api_gateway_deployment.my_deployment.invoke_url}/items/"
}