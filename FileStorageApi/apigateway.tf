#Create API GateWay

### 
resource "aws_api_gateway_rest_api" "FileUploderService" {
  name       = "${var.project}-API"
  depends_on = [aws_s3_bucket.user_content_bucket, aws_lambda_function.file_uploader_lambda]

}

resource "aws_api_gateway_resource" "FileUploderService" {
  parent_id   = aws_api_gateway_rest_api.FileUploderService.root_resource_id
  path_part   = "upload"
  rest_api_id = aws_api_gateway_rest_api.FileUploderService.id
}


resource "aws_api_gateway_method" "FileUploderService" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.FileUploderService.id
  rest_api_id   = aws_api_gateway_rest_api.FileUploderService.id
}

resource "aws_api_gateway_integration" "FileUploderService" {
  http_method             = aws_api_gateway_method.FileUploderService.http_method
  resource_id             = aws_api_gateway_resource.FileUploderService.id
  rest_api_id             = aws_api_gateway_rest_api.FileUploderService.id
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.file_uploader_lambda.invoke_arn
}





# Method Response and Enabling CORS

resource "aws_api_gateway_method_response" "FileUploderService" {
  rest_api_id = aws_api_gateway_rest_api.FileUploderService.id
  resource_id = aws_api_gateway_resource.FileUploderService.id
  http_method = aws_api_gateway_method.FileUploderService.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true
  }

}

resource "aws_api_gateway_deployment" "FileUploderService" {
  rest_api_id = aws_api_gateway_rest_api.FileUploderService.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.FileUploderService.id,
      aws_api_gateway_method.FileUploderService.id,
      aws_api_gateway_integration.FileUploderService.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.FileUploderService.id
  rest_api_id   = aws_api_gateway_rest_api.FileUploderService.id
  stage_name    = var.stage_name
}

# Permission for API Gateway to invoke lambda function
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_uploader_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.FileUploderService.execution_arn}/*/*"
  #${aws_api_gateway_method.FileUploderService.http_method}${aws_api_gateway_resource.FileUploderService.path}"
}



### Print API url into app.js

locals {

  apiGateWayUrl = "${aws_api_gateway_deployment.FileUploderService.invoke_url}prod/upload"
}

resource "null_resource" "replace_apiUrl" {
  provisioner "local-exec" {
    command = "sed -i 's#apiGateWayUrl#\"${local.apiGateWayUrl}\"#g' ${path.module}/website/app.js "
  }
}


resource "null_resource" "cp_website_to_s3" {

  provisioner "local-exec" {
    command = "aws s3 cp ${path.module}/website/ s3://${aws_s3_bucket.file_uploader_app_bucket.bucket} --recursive  --profile demos"
  }
  depends_on = [null_resource.replace_apiUrl]
}