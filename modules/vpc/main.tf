
resource "aws_vpc" "vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = "${var.enable_dns_hostnames}"
    enable_dns_support = "${var.enable_dns_support}"

    tags {
        Name = "${var.vpc_name}"
    }
} 

resource "aws_subnet" "public_subnet_01" {
    availability_zone = "${var.region}a"
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.public_subnet_01}"
    tags {
        Name = "${var.vpc_name}-subnet-public-01"
    }
}

resource "aws_subnet" "public_subnet_02" {
    availability_zone = "${var.region}e"
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.public_subnet_02}"
    tags {
        Name = "${var.vpc_name}-subnet-public-02"
    }
}

resource "aws_subnet" "private_subnet_01" {
  cidr_block        = "${var.private_subnet_01}"
  availability_zone = "${var.region}a"
  vpc_id            = "${aws_vpc.vpc.id}"
  tags {
        Name = "${var.vpc_name}-subnet-private-01"
  }
}

resource "aws_subnet" "private_subnet_02" {
  cidr_block        = "${var.private_subnet_02}"
  availability_zone = "${var.region}e"
  vpc_id            = "${aws_vpc.vpc.id}"
  tags {
        Name = "${var.vpc_name}-subnet-private-02"
  }
}

resource "aws_internet_gateway" "internet_gtw" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags {
        Name = "${var.vpc_name}-igw"
    }
}

resource "aws_eip" "gateway_eip_01" {
  vpc        = true
  depends_on = ["aws_internet_gateway.internet_gtw"]
}

resource "aws_nat_gateway" "nat_gateway_01" {
  subnet_id     = "${aws_subnet.public_subnet_01.id}"
  allocation_id = "${aws_eip.gateway_eip_01.id}"
}

resource "aws_route_table" "private_route_01" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gateway_01.id}"
  }
}
resource "aws_route_table_association" "private_assoc_01" {
  subnet_id      = "${aws_subnet.private_subnet_01.id}"
  route_table_id = "${aws_route_table.private_route_01.id}"
}

resource "aws_eip" "gateway_eip_02" {
  vpc        = true
  depends_on = ["aws_internet_gateway.internet_gtw"]
}

resource "aws_nat_gateway" "nat_gateway_02" {
  subnet_id     = "${aws_subnet.public_subnet_02.id}"
  allocation_id = "${aws_eip.gateway_eip_02.id}"
}

resource "aws_route_table" "private_route_02" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gateway_02.id}"
  }
}
resource "aws_route_table_association" "private_assoc_02" {
  subnet_id      = "${aws_subnet.private_subnet_02.id}"
  route_table_id = "${aws_route_table.private_route_02.id}"
}

resource "aws_route" "internet_access_route" {
    route_table_id = "${aws_vpc.vpc.main_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gtw.id}"
}

output "vpc_id" {
    value = "${aws_vpc.vpc.id}"
}
output "internet_gateway_id" {
    value = "${aws_internet_gateway.internet_gtw.id}"
}
output "cidr_block" {
    value = "${aws_vpc.vpc.cidr_block}"
}

output "private_subnet_01_id" {
    value = "${aws_subnet.private_subnet_01.id}"
}

output "private_subnet_02_id" {
    value = "${aws_subnet.private_subnet_02.id}"
}

output "public_subnet_01_id" {
    value = "${aws_subnet.public_subnet_01.id}"
}

output "public_subnet_02_id" {
    value = "${aws_subnet.public_subnet_02.id}"
}

