#Create API GateWay

### 
resource "aws_api_gateway_rest_api" "FileUploderService" {
  name = "${var.project}-API"
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
  http_method = aws_api_gateway_method.FileUploderService.http_method
  resource_id = aws_api_gateway_resource.FileUploderService.id
  rest_api_id = aws_api_gateway_rest_api.FileUploderService.id
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.file_uploader_lambda.invoke_arn
}