#Create IAM Role To Allow Lambda Access To get,putObjects/Logs

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

# Creating S3 policy for Lambda functiion role to get and put objects to S3 buck
# Creating S3 policy for Lambda functiion role to get and put objects to S3 buck
resource "aws_iam_policy" "auth_lambda_policy" {
  name        = "auth_lambda_policy"
  description = "IAM policy for Lambda to access Logs and S3"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = ["${var.sns_arn}"]
      },

      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:CopyObject"
        ]
        Resource = ["arn:aws:s3:::${var.main_bucket}/*"]
      },

      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:CopyObject"
        ]
        Resource = ["arn:aws:s3:::${var.resized_bucket}/*"]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

