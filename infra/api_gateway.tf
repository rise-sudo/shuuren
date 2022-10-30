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
        "Resource"  = "${aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.execution_arn}/*/*"
      }
    ]
  })
}