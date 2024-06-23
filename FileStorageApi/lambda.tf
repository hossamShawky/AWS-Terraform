#1- Create IAM Role For Lambda

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
##Policy
# Creating S3 policy for Lambda functiion role to get and put objects to S3 buck
data "aws_iam_policy_document" "lambda_policy_document" {
  statement {
    effect  = "Allow"
    actions = ["s3:ListBucket", "s3:GetObject", "s3:PutObject", "s3:CopyObject", "logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.user_content_bucket.bucket}/*",
    "arn:aws:s3:::${aws_s3_bucket.user_content_bucket.bucket}"]
  }
}
resource "aws_iam_policy" "lambda_policy" {
  name   = "lambda-policy"
  policy = data.aws_iam_policy_document.lambda_policy_document.json
}
# Attach Policy To Role
resource "aws_iam_role_policy_attachment" "lambda_role_policy" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_execution.name
}

#Creating the Lambda function using data resource
locals {
  lambda_src_dir           = "${path.module}/lambdacode/"
  lambda_function_zip_path = "${path.module}/lambda_function.zip"
}

data "archive_file" "lambda" {
  source_dir  = local.lambda_src_dir
  output_path = local.lambda_function_zip_path
  type        = "zip"
}

resource "aws_lambda_function" "file_uploader_lambda" {
  filename         = local.lambda_function_zip_path
  function_name    = "${var.project}-lambdaFunction"
  role             = aws_iam_role.lambda_execution.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = var.lambda_runtime
  timeout          = 25
  memory_size      = 128
  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.user_content_bucket.bucket,
    }
  }

}