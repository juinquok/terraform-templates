module "s3" {
  source      = "./modules/s3"
  namespace   = var.namespace
  bucket_name = var.bucket_name
}

module "api_gateway" {
  source           = "./modules/api_gateway"
  namespace        = var.namespace
  upload_bucket_id = module.s3.upload_bucket_id
  aws_region       = var.region
}