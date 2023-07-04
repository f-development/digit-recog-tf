resource "aws_ssm_parameter" "cloudfront_distribution_id" {
  name  = "${local.prefix}-cloudfront-distribution-id"
  type  = "String"
  value = aws_cloudfront_distribution.this.id
}
