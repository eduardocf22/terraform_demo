
variable "region" {
    description = "AWS region"
    default = "us-east-1"
}

variable "content_secret_token" {
    description = "token used to grant access from cloudfront to the origin"
    default = "NewSecret003###"
}

variable "bucket_name" {
    description = "Bucket Name"
    default = "demo-terraform01224"
}

variable "iam_deployer_username" {
    description = "User allowed to deploy content in the S3 Bucket"
    default = "demo_deployer"
} 

variable "index_file_path" {
    description = "index.html file to upload on S3 bucket"
    default = "./../static_website/index.html"
}


