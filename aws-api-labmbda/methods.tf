#GET ALL ITEMS
resource "aws_api_gateway_method" "get_items" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.items.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_get_items" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.items.id
  http_method             = aws_api_gateway_method.get_items.http_method
  integration_http_method = "POST"

  type = "AWS_PROXY"
  uri  = aws_lambda_function.my_lambda.invoke_arn
}


# resource "aws_api_gateway_method_response" "GET_all_method_response_200" {
#   rest_api_id = aws_api_gateway_rest_api.my_api.id
#   resource_id = aws_api_gateway_resource.items.id
#   http_method = aws_api_gateway_method.get_items.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers"     = true,
#     "method.response.header.Access-Control-Allow-Methods"     = true,
#     "method.response.header.Access-Control-Allow-Origin"      = true,
#     "method.response.header.Access-Control-Allow-Credentials" = true
#   }
# }

# resource "aws_api_gateway_integration_response" "GET_all_integration_response_200" {
#   rest_api_id = aws_api_gateway_rest_api.my_api.id
#   resource_id = aws_api_gateway_resource.items.id
#   http_method = aws_api_gateway_method.get_items.http_method
#   status_code = aws_api_gateway_method_response.GET_all_method_response_200.status_code

#   depends_on = [aws_api_gateway_integration.lambda_get_items]

#   response_templates = {
#     "application/json" = <<EOF
#     #set($inputRoot = $input.path('$.body'))
#     {
#       \"statusCode\": 200,
#       \"body\": $inputRoot,
#       \"headers\": {
#         \"Content-Type\": \"application/json\"
#       }
#     }
#     EOF
#   }
# }

# ### GET SPECIFIC ITEM
resource "aws_api_gateway_method" "get_item" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.item.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_get_item" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.item.id
  http_method             = aws_api_gateway_method.get_item.http_method
  integration_http_method = "POST"

  type = "AWS_PROXY"
  uri  = aws_lambda_function.my_lambda.invoke_arn
}
# resource "aws_api_gateway_method_response" "GET_item_method_response_200" {
#   rest_api_id = aws_api_gateway_rest_api.my_api.id
#   resource_id = aws_api_gateway_resource.item.id
#   http_method = aws_api_gateway_method.get_item.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers"     = true,
#     "method.response.header.Access-Control-Allow-Methods"     = true,
#     "method.response.header.Access-Control-Allow-Origin"      = true,
#     "method.response.header.Access-Control-Allow-Credentials" = true
#   }
# }
# resource "aws_api_gateway_integration_response" "GET_item_integration_response_200" {
#   rest_api_id = aws_api_gateway_rest_api.my_api.id
#   resource_id = aws_api_gateway_resource.item.id
#   http_method = aws_api_gateway_method.get_item.http_method
#   status_code = aws_api_gateway_method_response.GET_item_method_response_200.status_code

#   depends_on = [aws_api_gateway_integration.lambda_get_items]

#   response_templates = {
#     "application/json" = <<EOF
#     #set($inputRoot = $input.path('$.body'))
#     {
#       \"statusCode\": 200,
#       \"body\": $inputRoot,
#       \"headers\": {
#         \"Content-Type\": \"application/json\"
#       }
#     }
#     EOF
#   }
# }


# POST METHOD --> Insert
resource "aws_api_gateway_method" "post_item" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.item.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_post_item" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.item.id
  http_method             = aws_api_gateway_method.post_item.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.my_lambda.invoke_arn
}



# DELETE ITEM
resource "aws_api_gateway_method" "delete_item" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.item.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_delete_item" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.item.id
  http_method             = aws_api_gateway_method.delete_item.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.my_lambda.invoke_arn
}

##STATUS

resource "aws_api_gateway_method" "status" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.status.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_status" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.status.id
  http_method             = aws_api_gateway_method.status.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.my_lambda.invoke_arn
}



##UPDATE
resource "aws_api_gateway_method" "update_item" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.item.id
  http_method   = "PATCH"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_update_item" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.item.id
  http_method             = aws_api_gateway_method.update_item.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.my_lambda.invoke_arn
}




#DEPLOYEMNT

resource "aws_api_gateway_deployment" "my_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_get_items,
    aws_api_gateway_integration.lambda_get_item,
    aws_api_gateway_integration.lambda_post_item,
    aws_api_gateway_integration.lambda_delete_item,
  ]


  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = "prod"
}