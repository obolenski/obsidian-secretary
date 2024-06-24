output "invoke_url" {
  value = "${aws_api_gateway_deployment.obsidian_secretary_deployment.invoke_url}/${aws_api_gateway_resource.obsidian_secretary_resource.path_part}"
}
