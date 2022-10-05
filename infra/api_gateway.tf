resource "aws_api_gateway_rest_api" "shuuren_api_gateway_rest_api" {
  name = "shuuren"
}

resource "aws_api_gateway_domain_name" "shuuren_api_gateway_custom_domain" {
  certificate_arn = aws_acm_certificate_validation.shuuren_cert_validation.certificate_arn
  domain_name     = "api.shuuren.com"
}

resource "aws_api_gateway_rest_api_policy" "shuuren_api_policy" {
  rest_api_id = aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.id

  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Effect"    = "Allow"
        "Principal" = "*"
        "Action"    = "execute-api:Invoke"
        "Resource"  = ""arn:aws:execute-api:*:*:*""
      }
    ]
  })
}

resource "aws_api_gateway_deployment" "shuuren_api_deployment" {
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

resource "aws_api_gateway_stage" "shuuren_api_stage" {
  deployment_id = aws_api_gateway_deployment.shuuren_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.id
  stage_name    = "api"
}

resource "aws_api_gateway_base_path_mapping" "shuuren_api_mapping" {
  api_id      = aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.id
  stage_name  = aws_api_gateway_stage.shuuren_api_stage.stage_name
  domain_name = aws_api_gateway_domain_name.shuuren_api_gateway_custom_domain.domain_name
}
