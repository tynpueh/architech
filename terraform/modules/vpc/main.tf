resource "aws_vpc" "app" {
    cidr_block = "10.0.0.0/16"
    region = var.region
    tags = {
        Name = "${var.environment}-vpc"
    }
  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.app.id
    tags = {
        Name = "${var.environment}-igw"
    }
  
}


resource "aws_subnet" "public" {
    vpc_id            = aws_vpc.app.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "${var.environment}-public-subnet"
    }
}


resource "aws_subnet" "private" {
    vpc_id            = aws_vpc.app.id
    cidr_block        = "10.0.2.0/24"
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "${var.environment}-private-subnet"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.app.id
    tags = {
        Name = "${var.environment}-public-rt"
    }
  
}

resource "aws_route" "public_rt_route" {
    route_table_id         = aws_route_table.public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_rt_assoc" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.app.id
    tags = {
        Name = "${var.environment}-private-rt"
    }
  
}

resource "aws_route_table_association" "private_rt_assoc" {
    subnet_id      = aws_subnet.private.id
    route_table_id = aws_route_table.private_rt.id
}