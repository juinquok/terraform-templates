## Creates the API Gateway
resource "aws_api_gateway_rest_api" "s3_gateway" {
  name = "s3_gateway"
  endpoint_configuration {
    types = [
      "REGIONAL", 
    ]
  }
}

## Creates the URL root for uploading files
resource "aws_api_gateway_resource" "s3_deploy_object_root" {
  parent_id   = aws_api_gateway_rest_api.s3_gateway.root_resource_id
  path_part   = "file_upload"
  rest_api_id = aws_api_gateway_rest_api.s3_gateway.id
  depends_on  = [aws_api_gateway_rest_api.s3_gateway]
}

## Creates the resource which captures the filename
## Note: {object} is a special part path which is used to pass on the filename provided in the URL
resource "aws_api_gateway_resource" "s3_deploy_object" {
  parent_id   = aws_api_gateway_resource.s3_deploy_object_root.id
  path_part   = "{object}"
  rest_api_id = aws_api_gateway_rest_api.s3_gateway.id
  depends_on  = [aws_api_gateway_resource.s3_deploy_object_root]
}

## Creates the PUT method with the request parameters required
resource "aws_api_gateway_method" "s3_put" {
  authorization = "NONE"
  http_method   = "PUT"
  resource_id   = aws_api_gateway_resource.s3_deploy_object.id
  rest_api_id   = aws_api_gateway_rest_api.s3_gateway.id

  request_parameters = {
    "method.request.path.object" = true
  }

  depends_on = [aws_api_gateway_resource.s3_deploy_object]
}

## Creates the integration referencing the S3 bucket provided to this module
resource "aws_api_gateway_integration" "s3_integration" {
  type        = "AWS"
  http_method = "PUT"
  resource_id = aws_api_gateway_resource.s3_deploy_object.id
  rest_api_id = aws_api_gateway_rest_api.s3_gateway.id
  credentials = aws_iam_role.api_gateway_role.arn

  uri = "arn:aws:apigateway:${var.aws_region}:s3:path/${var.upload_bucket_id}/{object}"

  cache_key_parameters    = []
  integration_http_method = "PUT"
  passthrough_behavior    = "WHEN_NO_MATCH"
  request_templates       = {}
  timeout_milliseconds    = 29000

  request_parameters = {
    "integration.request.path.object" = "method.request.path.object"
  }

  depends_on = [aws_api_gateway_method.s3_put]
}

## Creates the defult 200 integration response for a successful upload
resource "aws_api_gateway_integration_response" "s3_response_200" {
  rest_api_id         = aws_api_gateway_rest_api.s3_gateway.id
  resource_id         = aws_api_gateway_resource.s3_deploy_object.id
  http_method         = aws_api_gateway_method.s3_put.http_method
  status_code         = aws_api_gateway_method_response.s3_response_200.status_code
  depends_on  = [aws_api_gateway_resource.s3_deploy_object, aws_api_gateway_integration.s3_integration]
  response_parameters = {}
  response_templates  = {}
}

## Creates the 5XX server response for a server error on upload
resource "aws_api_gateway_integration_response" "s3_response_500" {
  rest_api_id       = aws_api_gateway_rest_api.s3_gateway.id
  resource_id       = aws_api_gateway_resource.s3_deploy_object.id
  http_method       = aws_api_gateway_method.s3_put.http_method
  status_code       = aws_api_gateway_method_response.s3_response_500.status_code
  depends_on  = [aws_api_gateway_resource.s3_deploy_object, aws_api_gateway_integration.s3_integration]
  selection_pattern = "5\\d{2}"
}

## Creates the 4XX server response
resource "aws_api_gateway_integration_response" "s3_response_400" {
  rest_api_id       = aws_api_gateway_rest_api.s3_gateway.id
  resource_id       = aws_api_gateway_resource.s3_deploy_object.id
  http_method       = aws_api_gateway_method.s3_put.http_method
  status_code       = aws_api_gateway_method_response.s3_response_400.status_code
  depends_on  = [aws_api_gateway_resource.s3_deploy_object, aws_api_gateway_integration.s3_integration]
  selection_pattern = "4\\d{2}"
}

## Creates 200 method response that is returned to caller
resource "aws_api_gateway_method_response" "s3_response_200" {
  rest_api_id = aws_api_gateway_rest_api.s3_gateway.id
  resource_id = aws_api_gateway_resource.s3_deploy_object.id
  http_method = aws_api_gateway_method.s3_put.http_method
  status_code = "200"
  depends_on  = [aws_api_gateway_rest_api.s3_gateway]
  response_models = {
    "application/json" = "Empty"
  }
}

## Creates 400 method response that is returned to caller
resource "aws_api_gateway_method_response" "s3_response_400" {
  rest_api_id = aws_api_gateway_rest_api.s3_gateway.id
  resource_id = aws_api_gateway_resource.s3_deploy_object.id
  http_method = aws_api_gateway_method.s3_put.http_method
  status_code = "400"
  depends_on  = [aws_api_gateway_rest_api.s3_gateway]
}

## Creates 500 method response that is returned to caller
resource "aws_api_gateway_method_response" "s3_response_500" {
  rest_api_id = aws_api_gateway_rest_api.s3_gateway.id
  resource_id = aws_api_gateway_resource.s3_deploy_object.id
  http_method = aws_api_gateway_method.s3_put.http_method
  status_code = "500"
  depends_on  = [aws_api_gateway_rest_api.s3_gateway]
}

## Creates a deployment for the API Gateway
resource "aws_api_gateway_deployment" "s3_deploy" {
  rest_api_id = aws_api_gateway_rest_api.s3_gateway.id
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_api_gateway_integration.s3_integration]
}

## Creates a stage for the deployment
resource "aws_api_gateway_stage" "s3_deploy" {
  deployment_id = aws_api_gateway_deployment.s3_deploy.id
  rest_api_id   = aws_api_gateway_rest_api.s3_gateway.id
  stage_name    = var.namespace
  depends_on    = [aws_api_gateway_integration.s3_integration]
}

