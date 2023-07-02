module "s3__static" {
    source = "./modules/s3"
    prefix = local.prefix
    bucket_name = "static"
}