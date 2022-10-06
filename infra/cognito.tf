resource "aws_cognito_user_pool" "shuuren_user_pool" {
  name = "shuuren_user_pool"

  schema {
    name                = "email"
    attribute_data_type = "String"
    mutable             = false
    required            = true

    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }
}

resource "aws_cognito_user_pool_client" "shuuren_client" {
  name                                 = "shuuren_client"
  user_pool_id                         = aws_cognito_user_pool.shuuren_user_pool.id
  callback_urls                        = ["https://example.com/callback"]
  logout_urls                          = ["https://example.com/signout"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid"]
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "shuuren_auth_domain" {
  domain          = "auth.shuuren.com"
  certificate_arn = aws_acm_certificate.shuuren_cert.arn
  user_pool_id    = aws_cognito_user_pool.shuuren_user_pool.id
}