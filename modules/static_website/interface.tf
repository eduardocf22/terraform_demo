variable "region" {
    description = "AWS region"
}

variable "bucket_name" {
    description = "Bucket Name"
}

variable "content_secret_token" {
    description = "Token used to restrict S3 access, allowing Cloudfront only" 
}

variable "iam_deployer_username" {
    description = "User allowed to deploy content in the S3 Bucket"
    default = "deploy_user"
} 

variable "s3_bucket_routing_rules" {
    description = "routing rules for pages and paths"
    default = ""
}

variable "index_file_path" {
    description = "path to the file object to upload to S3 bucket"
}

variable "forward-query-string" {
    description = "Forward the query string to the origin"
    default = true
}

variable "not-found-response-path" {
    default = "/404.html"
}

