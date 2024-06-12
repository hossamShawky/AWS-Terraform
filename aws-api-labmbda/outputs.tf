output "dynamodb_table_name" {
  value = aws_dynamodb_table.Dynamodb.name
}

output "lambda_function_name" {
  value = aws_lambda_function.my_lambda.function_name
}