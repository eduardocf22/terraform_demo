
data "template_file" "bucket_policy" {
   template = "${file("${path.module}/s3_bucket_policy.json")}"
   vars {
     bucket = "${var.bucket_name}"
     secret = "${var.content_secret_token}"
   }
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "${var.bucket_name}"
  region = "${var.region}"
  acl = "public-read"
  policy = "${data.template_file.bucket_policy.rendered}"

  website {
    index_document = "index.html"
    error_document = "404.html"
    routing_rules  = "${var.s3_bucket_routing_rules}"
  }
  tags {
      Name = "${var.bucket_name}"
  }
}

data "template_file" "deployer_policy_template" {
    template = "${file("${path.module}/deployer_policy.json")}"
    vars {
        bucket = "${var.bucket_name}"
    }
}

resource "aws_iam_user" "deployer_iam_user" {
    name = "${var.iam_deployer_username}"
    path = "/"
    force_destroy = true
}

resource "aws_iam_policy" "deployer_policy" {
    name = "${var.bucket_name}_deployer_pol"
    path = "/"
    description = "This policy grants deployment rights to IAM user."
    policy = "${data.template_file.deployer_policy_template.rendered}"
}

resource "aws_iam_user_policy_attachment" "deployer_policy_attachment" {
    user = "${aws_iam_user.deployer_iam_user.name}"
    policy_arn = "${aws_iam_policy.deployer_policy.arn}"
}

resource "aws_s3_bucket_object" "index_page" {
    bucket = "${var.bucket_name}"
    key = "index.html"
    content_type = "text/html"
    source = "${var.index_file_path}"
    etag = "${md5(file(var.index_file_path))}"
}

data "aws_s3_bucket" "selected" {
  bucket = "${var.bucket_name}"
}

resource "aws_cloudfront_distribution" "cdn" {
    enabled = true
    price_class = "PriceClass_100"
    http_version = "http2"

    origin {
        origin_id = "${var.bucket_name}"
        domain_name = "${data.aws_s3_bucket.selected.website_endpoint}"

        custom_origin_config {
            origin_protocol_policy = "match-viewer"
            http_port = "80"
            https_port = "443"
            origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
        }
         custom_header {
            name  = "User-Agent"
            value = "${var.content_secret_token}"
         }
    }
    default_root_object = "index.html"

    custom_error_response {
        error_code = "404"
        error_caching_min_ttl = "360"
        response_code         = "200"
        response_page_path    = "${var.not-found-response-path}"
    }
    default_cache_behavior {
        allowed_methods = ["GET", "HEAD", "DELETE", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods  = ["GET", "HEAD"]
        forwarded_values {
            query_string = "${var.forward-query-string}"
            cookies {
                forward = "none"
            }
        }
        viewer_protocol_policy = "allow-all"
        min_ttl = "0"
        default_ttl = "300"                                              
        max_ttl = "1200"                                            
        target_origin_id = "${var.bucket_name}"
    }
    restrictions {
        geo_restriction {
        restriction_type = "none"
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }

    tags {
        Name = "terraform-demo-cdn"
    }
}

output "bucket_arn" {
    value = "${aws_s3_bucket.website_bucket.arn}"
}

output "bucket_domain_name" {
    value = "${data.aws_s3_bucket.selected.bucket_domain_name}"
}

output "website_endpoint" {
    value = "${aws_s3_bucket.website_bucket.website_endpoint}"
}

output "cdn_id" {
    value = "${aws_cloudfront_distribution.cdn.id}"
}
output "cdn_domain_name" {
    value = "${aws_cloudfront_distribution.cdn.domain_name}"
}