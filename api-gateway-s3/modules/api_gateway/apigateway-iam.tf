resource "aws_iam_role" "api_gateway_role" {
  name               = "API-GATEWAY-ROLE"
  assume_role_policy = data.aws_iam_policy_document.gateway_s3_policy.json
}

data "aws_iam_policy_document" "api_gateway_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  } 
}

## You can choose to further limit the resources that the API Gateway is allowed to access
resource "aws_iam_role_policy" "gateway_s3_policy" {
  name   = "GATEWAY-S3-POLICY"
  role   = aws_iam_role.api_gateway_role.id
  policy = data.aws_iam_policy_document.gateway_s3_policy.json
}

data "aws_iam_policy_document" "gateway_s3_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]
    resources = ["*"]
  }
}