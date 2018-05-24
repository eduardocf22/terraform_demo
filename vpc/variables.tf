
variable "region" {
    description = "AWS region"
    default = "us-east-1"
}

variable "vpc_name" {
    description = "VPC name"
    default = "terraform_demo_vpc"
}

variable "vpc_cidr" {
    description = "VPC CIDR"
    default = "10.20.0.0/16"
}
variable "public_subnet" {
    description = "public subnet"
    default = "10.30.0.0/24"
}

variable "public_subnet_02" {
    description = "public subnet 02"
    default = "10.20.1.0/24"
}

variable "private_subnet_01" {
    description = "public subnet 02"
    default = "10.30.10.0/24"
}

variable "private_subnet_02" {
    description = "public subnet 02"
    default = "10.20.11.0/24"
}

