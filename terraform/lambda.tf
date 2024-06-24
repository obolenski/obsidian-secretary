resource "aws_lambda_function" "obsidian_secretary" {
  filename         = "${path.module}/../lambda/lambda.zip"
  description      = "telegram bot that interacts with an obsidian vault"
  function_name    = "obsidian-secretary"
  role             = aws_iam_role.obsidian_secretary_role.arn
  handler          = "obsidian_secretary_telegram.lambda_handler"
  runtime          = "python3.12"
  timeout          = "60"
  source_code_hash = filebase64sha256("${path.module}/../lambda/lambda.zip")

  environment {
    variables = {
      telegram_token   = "secret"
      telegram_chat_id = "secret"
      gh_username      = "secret"
      gh_token         = "secret"
      gh_repo          = "secret"
    }
  }

  lifecycle {
    ignore_changes = [environment]
  }

  layers = [
    aws_lambda_layer_version.python-deps.arn
  ]
  tags = local.tags
}

resource "aws_lambda_layer_version" "python-deps" {
  filename   = "${path.module}/../lambda/python-deps-layer.zip"
  layer_name = "python-deps-layer"
  compatible_runtimes = [
    "python3.12"
  ]
  source_code_hash = filebase64sha256("${path.module}/../lambda/python-deps-layer.zip")
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.obsidian_secretary.function_name}"
  retention_in_days = 5
  tags              = local.tags
}
