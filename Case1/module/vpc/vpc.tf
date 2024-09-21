
resource "aws_vpc" "custom_vpc" {
    cidr_block = var.CUSTOM_VPC_CIDR_BLOC
    enable_dns_support = "true"
    enable_dns_hostnames = "true"

    tags = {
      Name = "${var.ENVIRONMENT}-vpc"
    }
  
}

resource "aws_subnet" "custom_vpc_public_subnet_1" {
    vpc_id = aws_vpc.custom_vpc.id
    cidr_block = var.CUSTOM_VPC_PUBLIC_SUBNET1_CIDR_BLOCK
    availability_zone = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = "true"

    tags ={

        Name = "${Var.ENVIRONMENT}-custom-vpc-public-subnet-1"
    }
  
}

resource "aws_subnet" "custom_vpc_public_subnet_2" {
    vpc_id = aws_vpc.custom_vpc.id
    cidr_block = var.CUSTOM_VPC_PUBLIC_SUBNET2_CIDR_BLOCK
    availability_zone = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = "true"

    tags ={

        Name = "${Var.ENVIRONMENT}-custom-vpc-public-subnet-2"
    }
  
}


resource "aws_subnet" "custom_vpc_private_subnet_1" {
    vpc_id = aws_vpc.custom_vpc.id
    cidr_block = var.CUSTOM_VPC_PRIVATE_SUBNET1_CIDR_BLOCK
    availability_zone = data.aws_availability_zones.available.names[0]
    

    tags ={

        Name = "${Var.ENVIRONMENT}-custom-vpc-private-subnet-1"
    }
  
}

resource "aws_subnet" "custom_vpc_private_subnet_2" {
    vpc_id = aws_vpc.custom_vpc.id
    cidr_block = var.CUSTOM_VPC_PRIVATE_SUBNET2_CIDR_BLOCK
    availability_zone = data.aws_availability_zones.available.names[1]
    

    tags ={

        Name = "${Var.ENVIRONMENT}-custom-vpc-private-subnet-2"
    }
  
}

resource "aws_internet_gateway" "custom_vpc-igw" {
    vpc_id = aws_vpc.custom_vpc.id

    tags ={

        Name = "${Var.ENVIRONMENT}-custom-vpc-igw"
    }
  
}

resource "aws_eip" "custom_nat_eip" {
    depends_on = [ aws_internet_gateway.custom_vpc-igw ]

}

resource "aws_nat_gateway" "custom_vpc-nat-gateway" {
    allocation_id = aws_eip.custom_nat_eip.id
    subnet_id = aws_subnet.custom_vpc_public_subnet_1.id
    depends_on = [ aws_internet_gateway.custom_vpc-igw ]

  tags ={

        Name = "${Var.ENVIRONMENT}-custom-vpc-nat-gateway"
    }  
  
}

resource "aws_route_table" "custom-public" {
    vpc_id = aws_vpc.custom_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.custom_vpc-igw.id
    
    }

    tags ={

        Name = "${Var.ENVIRONMENT}-custom-vpc-public-route"
    }  
  
}

resource "aws_route_table" "custom-private" {
    vpc_id = aws_vpc.custom_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.custom_vpc-nat-gateway.id
    
    }

    tags ={

        Name = "${Var.ENVIRONMENT}-custom-vpc-private-route"
    }  
  
}

resource "aws_route_table_association" "to_public_1" {
    subnet_id = aws_subnet.custom_vpc_public_subnet_1.id
    route_table_id = aws_route_table.custom-public.id
  
}
resource "aws_route_table_association" "to_public_2" {
    subnet_id = aws_subnet.custom_vpc_public_subnet_2.id
    route_table_id = aws_route_table.custom-public.id
  
}

resource "aws_route_table_association" "to_private_1" {
    subnet_id = aws_subnet.custom_vpc_private_subnet_1.id
    route_table_id = aws_route_table.custom-private.id
  
}

resource "aws_route_table_association" "to_private_2" {
    subnet_id = aws_subnet.custom_vpc_private_subnet_2.id
    route_table_id = aws_route_table.custom-private.id
  
}