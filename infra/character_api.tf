resource "aws_api_gateway_resource" "shuuren_api_character" {
  parent_id   = aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.root_resource_id
  path_part   = "character"
  rest_api_id = aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.id
}

data "archive_file" "character" {
  type             = "zip"
  source_dir       = "${path.module}/api/character"
  output_file_mode = "0666"
  output_path      = "character.zip"
}

resource "aws_iam_role" "character_api_role" {
  name = "character_api_role"

  assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Action" = "sts:AssumeRole",
        "Principal" = {
          "Service" = "lambda.amazonaws.com"
        },
        "Effect" = "Allow",
        "Sid"    = ""
      }
    ]
  })
}

resource "aws_iam_policy" "character_api_policy" {
  name        = "character_api_policy"
  path        = "/"
  description = "iam policy for character api lambda"

  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Action" = [
          "dynamodb:BatchGetItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchWriteItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ],
        "Resource" = "arn:aws:dynamodb:*:*:*"
        "Effect"   = "Allow"
      },
      {
        "Action" = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" = "arn:aws:logs:*:*:*",
        "Effect"   = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "character_api_policy_attachment" {
  role       = aws_iam_role.character_api_role.name
  policy_arn = aws_iam_policy.character_api_policy.arn
}

resource "aws_lambda_function" "update_character" {
  filename         = "character.zip"
  function_name    = "update_character"
  role             = aws_iam_role.character_api_role.arn
  handler          = "update_character.update_character_handler"
  source_code_hash = data.archive_file.character.output_base64sha256
  runtime          = "python3.9"
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_character.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.execution_arn}/*/*/*"
}

resource "aws_api_gateway_method" "shuuren_api_character_put" {
  authorization = "NONE"
  http_method   = "PUT"
  resource_id   = aws_api_gateway_resource.shuuren_api_character.id
  rest_api_id   = aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.id
}

resource "aws_api_gateway_integration" "update_character_integration" {
  rest_api_id             = aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.id
  resource_id             = aws_api_gateway_resource.shuuren_api_character.id
  http_method             = aws_api_gateway_method.shuuren_api_character_put.http_method
  integration_http_method = "PUT"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.update_character.invoke_arn
}