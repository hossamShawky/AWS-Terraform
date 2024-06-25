locals {
  lambda_src_dir           = "${path.module}/../resize_lambda/"
  lambda_function_zip_path = "${path.module}/../resize_lambda.zip"
}

data "archive_file" "lambda" {
  source_dir  = local.lambda_src_dir
  output_path = local.lambda_function_zip_path
  type        = "zip"
}

resource "aws_lambda_function" "resize_lambda" {
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
      MAIN_BUCKET    = var.main_bucket,
      RESIZED_BUCKET = var.resized_bucket,
      TOPIC_ARN      = var.sns_arn
    }
  }

}

#Main S3 Trigger  With Lambda


resource "aws_lambda_permission" "trigger-lambda" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.resize_lambda.id
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.main_bucket}"
}

resource "aws_s3_bucket_notification" "bucket_notifiy" {
  bucket = var.main_bucket
  lambda_function {
    lambda_function_arn = aws_lambda_function.resize_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""
    filter_suffix       = ""

  }
  depends_on = [aws_lambda_permission.trigger-lambda]

}