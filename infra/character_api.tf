resource "aws_api_gateway_resource" "api_character_resource" {
  parent_id   = aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.root_resource_id
  path_part   = "character"
  rest_api_id = aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.id
}

data "archive_file" "api_character_file" {
  type             = "zip"
  source_dir       = "${path.module}/api/character"
  output_file_mode = "0666"
  output_path      = "character.zip"
}

resource "aws_iam_role" "api_character_role" {
  name = "api_character_role"

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

resource "aws_iam_policy" "api_character_policy" {
  name        = "api_character_policy"
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

resource "aws_iam_role_policy_attachment" "api_character_policy_attachment" {
  role       = aws_iam_role.api_character_role.name
  policy_arn = aws_iam_policy.api_character_policy.arn
}

resource "aws_lambda_function" "api_character_function" {
  filename         = "character.zip"
  function_name    = "character"
  role             = aws_iam_role.api_character_role.arn
  handler          = "character.character_handler"
  source_code_hash = data.archive_file.api_character_file.output_base64sha256
  runtime          = "python3.9"
}

resource "aws_lambda_permission" "api_character_permission" {
  statement_id  = "APICharacterPermission"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_character_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.execution_arn}/*/${aws_api_gateway_method.api_character_method.http_method}${aws_api_gateway_resource.api_character_resource.path}"
}

resource "aws_api_gateway_method" "api_character_method" {
  authorization = "NONE"
  http_method   = "ANY"
  rest_api_id   = aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.id
  resource_id   = aws_api_gateway_resource.api_character_resource.id
}

resource "aws_api_gateway_integration" "api_character_integration" {
  http_method             = aws_api_gateway_method.api_character_method.http_method
  rest_api_id             = aws_api_gateway_rest_api.shuuren_api_gateway_rest_api.id
  resource_id             = aws_api_gateway_resource.api_character_resource.id
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_character_function.invoke_arn
}