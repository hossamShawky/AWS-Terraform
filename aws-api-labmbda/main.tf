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
