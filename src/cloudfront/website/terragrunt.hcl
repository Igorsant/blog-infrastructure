terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-cloudfront.git"
}

include {
  path = find_in_parent_folders()
}

dependency "s3" {
  config_path = "../../s3/website"
}

inputs = {
  comment             = "My awesome CloudFront"
  enabled             = true
  http_version        = "http2and3"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_200"
  wait_for_deployment = false

  create_origin_access_control = true
  origin_access_control = {
    s3_oac = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  origin = {
    s3_oac = {
      domain_name           = dependency.s3.outputs.s3_bucket_bucket_domain_name
      origin_access_control = "s3_oac"
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3_oac"
    viewer_protocol_policy = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }

  custom_error_response = [{
    error_code         = 404
    response_code      = 404
    response_page_path = "/index.html"
    }, {
    error_code         = 403
    response_code      = 403
    response_page_path = "/index.html"
  }]

  geo_restriction = {
    restriction_type = "whitelist"
    locations        = ["US", "BR"]
  }
}
