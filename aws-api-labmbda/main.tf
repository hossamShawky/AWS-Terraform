#1- Create   Dynamodb

resource "aws_dynamodb_table" "Dynamodb" {
  name         = "${var.project}-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}


# DynamoDB table item
resource "aws_dynamodb_table_item" "initial_user" {
  table_name = aws_dynamodb_table.Dynamodb.name
  hash_key   = "id"

  item = jsonencode({
    id = { S = "item-1" },
  })
}

#-2 Create Role For Lambda
resource "aws_iam_role" "lambda_execution" {
  name               = "lambda_execution_role"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "lambda_execution_attach" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
# Create custom IAM policy for DynamoDB access
resource "aws_iam_policy" "dynamodb_access_policy" {
  name = "lambda_dynamodb_access_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:Scan",
        "dynamodb:Query",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem"
      ],
      Resource = "${aws_dynamodb_table.Dynamodb.arn}"
    }]
  })
}

# Attach custom IAM policy to Lambda execution role
resource "aws_iam_policy_attachment" "lambda_dynamodb_attach" {
  name       = "lambda_dynamodb_attachment"
  roles      = [aws_iam_role.lambda_execution.name]
  policy_arn = aws_iam_policy.dynamodb_access_policy.arn
}



##ZIP CODE

resource "null_resource" "zip_code" {
  provisioner "local-exec" {
    command = " cd lambda/ &&  zip -r ./main.zip ."
  }
}
#3- Create Lambda
resource "aws_lambda_function" "my_lambda" {
  filename         = "${path.module}/lambda/main.zip"
  function_name    = "my_lambda_function"
  role             = aws_iam_role.lambda_execution.arn
  handler          = "main.lambda_handler"
  source_code_hash = filebase64sha256("${path.module}/lambda/main.zip")
  runtime          = "python3.9"
}

#4- Create API
resource "aws_api_gateway_rest_api" "my_api" {
  name        = "${var.project}-API"
  description = "My API Gateway To Invoke BackEnd Lambda"
  depends_on  = [aws_lambda_function.my_lambda]
}

resource "aws_api_gateway_resource" "items" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "resource"
}


#Grant API Access To invoke Lambda

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/*"
}