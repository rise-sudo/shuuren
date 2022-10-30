resource "aws_api_gateway_deployment" "shuuren_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      data.archive_file.character.output_base64sha256
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