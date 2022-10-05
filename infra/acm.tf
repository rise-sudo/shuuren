resource "aws_acm_certificate" "shuuren_cert" {
  domain_name       = "shuuren.com"
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "shuuren_cert_validation" {
  certificate_arn = aws_acm_certificate.shuuren_cert.arn
}