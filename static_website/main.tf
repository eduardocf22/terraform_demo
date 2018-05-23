provider "aws" {
    region = "${var.region}"
    version = "~> 1.19"
}

provider "template" {
    version = "~> 1.0"
}

provider "local" {
   version = "~> 1.1"
}

module "static_website" {
    source = "../modules/static_website"
    region = "${var.region}"
    bucket_name = "${var.bucket_name}"
    content_secret_token = "${var.content_secret_token}"
    iam_deployer_username = "${var.iam_deployer_username}"
    index_file_path = "${var.index_file_path}"
}

output "bucket_arn" {
    value = "${module.static_website.bucket_arn}"
}

output "bucket_domain_name" {
    value = "${module.static_website.bucket_domain_name}"
}

output "website_endpoint" {
    value = "${module.static_website.website_endpoint}"
}

output "cdn_id" {
    value = "${module.static_website.cdn_id}"
}
output "cdn_domain_name" {
    value = "${module.static_website.cdn_domain_name}"
}