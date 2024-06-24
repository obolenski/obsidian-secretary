resource "aws_api_gateway_rest_api" "obsidian_secretary_api" {
  name        = "obsidian-secretary-api"
  description = "API Gateway for Obsidian Secretary"
  tags        = local.tags
}

resource "aws_api_gateway_resource" "obsidian_secretary_resource" {
  rest_api_id = aws_api_gateway_rest_api.obsidian_secretary_api.id
  parent_id   = aws_api_gateway_rest_api.obsidian_secretary_api.root_resource_id
  path_part   = "obsidian-secretary"
}

resource "aws_api_gateway_method" "obsidian_secretary_method" {
  rest_api_id   = aws_api_gateway_rest_api.obsidian_secretary_api.id
  resource_id   = aws_api_gateway_resource.obsidian_secretary_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "obsidian_secretary_integration" {
  rest_api_id             = aws_api_gateway_rest_api.obsidian_secretary_api.id
  resource_id             = aws_api_gateway_resource.obsidian_secretary_resource.id
  http_method             = aws_api_gateway_method.obsidian_secretary_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.obsidian_secretary.invoke_arn
}

resource "aws_api_gateway_deployment" "obsidian_secretary_deployment" {
  rest_api_id = aws_api_gateway_rest_api.obsidian_secretary_api.id
  stage_name  = "prod"
  depends_on  = [aws_api_gateway_integration.obsidian_secretary_integration]
}

resource "aws_lambda_permission" "api_gateway_invoke_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.obsidian_secretary.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.obsidian_secretary_api.execution_arn}/*/*/${aws_api_gateway_resource.obsidian_secretary_resource.path_part}"
}
