
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

module "vpc" {
    source = "../modules/vpc"
    vpc_name = "${var.vpc_name}"
    vpc_cidr = "${var.vpc_cidr}"
    public_subnet = "${var.public_subnet}"
    public_subnet_02 = "${var.public_subnet_02}"
    private_subnet_01 = "${var.private_subnet_01}"
    private_subnet_02 = "${var.private_subnet_02}"
    enable_dns_hostnames = true
    enable_dns_support = true
    region = "${var.region}"
}