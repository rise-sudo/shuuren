resource "aws_api_gateway_rest_api" "shuuren_api_gateway_rest_api" {
  name = "shuuren"
}

resource "aws_api_gateway_resource" "shuuren_api_gateway_resource" {
  parent_id   = aws_api_gateway_rest_api.shuuren_api_gateway.root_resource_id
  path_part   = "api"
  rest_api_id = aws_api_gateway_rest_api.shuuren_api_gateway.id
}