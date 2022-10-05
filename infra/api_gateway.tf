resource "aws_api_gateway_rest_api" "shuuren_api_gateway_rest_api" {
  name = "shuuren"
}

resource "aws_api_gateway_domain_name" "shuuren_api_gateway_custom_domain" {
  certificate_arn = aws_acm_certificate_validation.shuuren_cert_validation.certificate_arn
  domain_name     = "shuuren.com"
}

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
  http_method = aws_api_gateway_method.shuuren_api_user_get.http_method
  resource_id = aws_api_gateway_resource.shuuren_api_user.id
  rest_api_id = aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.id
  type        = "MOCK"
}

resource "aws_api_gateway_deployment" "shuuren_api_user_get_deployment" {
  rest_api_id = aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.shuuren_api_user.id,
      aws_api_gateway_method.shuuren_api_user_get.id,
      aws_api_gateway_integration.shuuren_api_user_get_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "shuuren_api_user_get_stage" {
  deployment_id = aws_api_gateway_deployment.shuuren_api_user_get_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.id
  stage_name    = "api"
}
