data "archive_file" "signup_post_confirmation" {
  type             = "zip"
  source_file      = "${path.root}/../event/signup/post_confirmation.py"
  output_file_mode = "0666"
  output_path      = "${path.root}/signup_post_confirmation.zip"
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

resource "aws_lambda_function" "signup_post_confirmation" {
  filename         = "signup_post_confirmation.zip"
  function_name    = "signup_post_confirmation"
  role             = aws_iam_role.signup_event_role.arn
  handler          = "post_confirmation.post_confirmation_handler"
  source_code_hash = data.archive_file.signup_post_confirmation.output_base64sha256
  runtime          = "python3.9"
}

resource "aws_lambda_permission" "allow_cognito_post_confirmation" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.signup_post_confirmation.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.shuuren_user_pool.arn
}