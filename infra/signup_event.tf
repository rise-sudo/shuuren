data "archive_file" "signup" {
  type             = "zip"
  source_dir       = "${path.module}/events/signup"
  output_file_mode = "0666"
  output_path      = "signup.zip"
}

resource "aws_iam_role" "signup_event_role" {
  name = "signup_event_role"

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

resource "aws_iam_policy" "signup_event_policy" {
  name        = "signup_event_policy"
  path        = "/"
  description = "iam policy for signup event lambda"

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

resource "aws_iam_role_policy_attachment" "signup_event_policy_attachment" {
  role       = aws_iam_role.signup_event_role.name
  policy_arn = aws_iam_policy.signup_event_policy.arn
}

resource "aws_lambda_function" "signup_post_confirmation" {
  filename         = "signup.zip"
  function_name    = "signup_post_confirmation"
  role             = aws_iam_role.signup_event_role.arn
  handler          = "post_confirmation.post_confirmation_handler"
  source_code_hash = data.archive_file.signup.output_base64sha256
  runtime          = "python3.9"
}

resource "aws_lambda_permission" "allow_cognito_post_confirmation" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.signup_post_confirmation.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.shuuren_user_pool.arn
}