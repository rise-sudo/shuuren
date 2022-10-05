resource "aws_api_gateway_resource" "shuuren_api_user" {
  parent_id   = aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.root_resource_id
  path_part   = "user"
  rest_api_id = aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.id
}

resource "aws_api_gateway_method" "shuuren_api_user_get" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.shuuren_api_user.id
  rest_api_id   = aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.id
}

resource "aws_api_gateway_integration" "shuuren_api_user_get_integration" {
  http_method             = aws_api_gateway_method.shuuren_api_user_get.http_method
  resource_id             = aws_api_gateway_resource.shuuren_api_user.id
  rest_api_id             = aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.id
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  type                    = "HTTP"
  uri                     = "https://catfact.ninja/fact"
}