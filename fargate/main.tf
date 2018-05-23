
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

data "aws_vpc" "selected" {
   tags {
        Name = "${var.vpc_name}"
    }
}

data "aws_subnet" "public_subnet_01" {
    vpc_id = "${data.aws_vpc.selected.id}"
    availability_zone = "${var.region}a"
    cidr_block = "${var.public_subnet_01}"
}

data "aws_subnet" "public_subnet_02" {
    vpc_id = "${data.aws_vpc.selected.id}"
    availability_zone = "${var.region}e"
    cidr_block = "${var.public_subnet_02}"
}

data "aws_subnet" "private_subnet_01" {
    vpc_id = "${data.aws_vpc.selected.id}"
    availability_zone = "${var.region}a"
    cidr_block = "${var.private_subnet_01}"
} 

data "aws_subnet" "private_subnet_02" {
    vpc_id = "${data.aws_vpc.selected.id}"
    availability_zone = "${var.region}e"
    cidr_block = "${var.private_subnet_02}"
} 

module "fargate" {
    source = "../modules/fargate"
    vpc_id = "${data.aws_vpc.selected.id}"
    public_subnet_id_list = "${data.aws_subnet.public_subnet_01.id},${data.aws_subnet.public_subnet_02.id}"
    private_subnet_id_list = "${data.aws_subnet.private_subnet_01.id},${data.aws_subnet.private_subnet_02.id}"
    fargate_cpu = "256"
    fargate_memory = "512"
    docker_image = "nginx"
    app_name = "terraform_demo"
    app_port = 80
    alb_ext_port = 80
    number_of_containers = 2
}

output "vpc_id" {
    value = "${data.aws_vpc.selected.id}"
}

output "ecs_service_endpoint" {
    value = "${module.fargate.ecs_service_endpoint}"
}


