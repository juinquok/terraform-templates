variable "namespace" {
  description = "Deployment Namespace for Tracking Purposes"
  default     = "[DEV]TERRAFORM-TEMPLATES"
  type        = string
}

variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "bucket_name" {
  description = "S3 Bucket Name"
  default     = "APIGATEWAY_UPLOAD_BUCKET"
  type        = string
}