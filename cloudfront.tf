locals {
  static_bucket_origin_id = "static-bucket"
}

resource "aws_cloudfront_origin_access_control" "static" {
  name                              = "static-bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  comment             = local.prefix
  default_root_object = "index.html"

  origin {
    domain_name              = module.s3__static.bucket_regional_domain_name
    origin_id                = local.static_bucket_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.static.id
  }

  logging_config {
    include_cookies = false
    bucket          = module.s3__logging.bucket_domain_name
    prefix          = "cloudfront/"
  }

  default_cache_behavior {
    allowed_methods        = ["HEAD", "GET"]
    cached_methods         = ["HEAD", "GET"]
    target_origin_id       = local.static_bucket_origin_id
    cache_policy_id        = aws_cloudfront_cache_policy.cache_forever.id
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  depends_on = [aws_cloudfront_cache_policy.cache_forever]
}

resource "aws_cloudfront_cache_policy" "cache_forever" {
  name        = "${local.prefix}-default"
  default_ttl = 2147483647
  max_ttl     = 2147483647
  min_ttl     = 2147483647
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["Host"]
      }
    }
    query_strings_config {
      query_string_behavior = "all"
    }
  }
}

resource "aws_cloudfront_monitoring_subscription" "this" {
  distribution_id = aws_cloudfront_distribution.this.id

  monitoring_subscription {
    realtime_metrics_subscription_config {
      realtime_metrics_subscription_status = "Enabled"
    }
  }
}

resource "aws_s3_bucket_policy" "origin_access_control" {
  bucket = module.s3__static.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : {
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "cloudfront.amazonaws.com"
      },
      "Action" : "s3:GetObject",
      "Resource" : "${module.s3__static.arn}/*",
      "Condition" : {
        "StringEquals" : {
          "AWS:SourceArn" : aws_cloudfront_distribution.this.arn
        }
      }
    }
  })
}
