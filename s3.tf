module "s3__static" {
  source      = "./modules/s3"
  prefix      = local.prefix
  bucket_name = "static"
}

module "s3__logging" {
  source      = "./modules/s3"
  prefix      = local.prefix
  bucket_name = "cloudfront-logging"
  enable_acl = true
}
