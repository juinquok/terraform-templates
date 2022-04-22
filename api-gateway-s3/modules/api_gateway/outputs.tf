output "invoke_url" {
  description = "URL to invoke the file upload"
  value       = aws_api_gateway_stage.s3_deploy.invoke_url
}