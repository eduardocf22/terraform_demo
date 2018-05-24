
variable "region" {
    description = "AWS Region"
}

variable "vpc_name" {
    description = "VPC name"
}

variable "vpc_cidr" {
    description = "CIDR of the VPC"
}

variable "public_subnet_01" {
    description = "Public subnet CIDR"
}

variable "public_subnet_02" {
    description = "Public subnet CIDR"
}

variable "private_subnet_01" {
    description = "Private subnet"
}

variable "private_subnet_02" {
    description = "Private subnet"
}

variable "enable_dns_hostnames" {
    description = "Enable DNS within VPC"
    default = true
}

variable "enable_dns_support" {
    description = "Enable DNS within VPC"
    default = true
}