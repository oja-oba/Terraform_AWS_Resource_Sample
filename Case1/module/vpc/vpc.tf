#The VPC COMPONENT FILE#
#AUTHOR: OJA-OBA
#DATE: 9/22/2024
#The resources declared here are the VPC, the internet gateway , the elastic IP, the NAT gateway, the private,
# public subnets, the route table for the private and public subnets. The table associations#
#The Outputs are the VPC ID, the public and private subnets ids #




#AWS VPC RESOURCE
resource "aws_vpc" "custom_vpc" {
    cidr_block = var.CUSTOM_VPC_CIDR_BLOC
    enable_dns_support = "true"
    enable_dns_hostnames = "true"

    tags = {
      Name = "${var.ENVIRONMENT}-vpc"
    }
  
}

#Subnet Resource for public subnet 1
resource "aws_subnet" "custom_vpc_public_subnet_1" {
    vpc_id = aws_vpc.custom_vpc.id
    cidr_block = var.CUSTOM_VPC_PUBLIC_SUBNET1_CIDR_BLOCK
    availability_zone = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = "true"

    tags ={

        Name = "${var.ENVIRONMENT}-custom-vpc-public-subnet-1"
    }
  
}

#Subnet Resource for public subnet 2
resource "aws_subnet" "custom_vpc_public_subnet_2" {
    vpc_id = aws_vpc.custom_vpc.id
    cidr_block = var.CUSTOM_VPC_PUBLIC_SUBNET2_CIDR_BLOCK
    availability_zone = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = "true"

    tags ={

        Name = "${var.ENVIRONMENT}-custom-vpc-public-subnet-2"
    }
  
}


#Subnet Resource for private subnet 1
resource "aws_subnet" "custom_vpc_private_subnet_1" {
    vpc_id = aws_vpc.custom_vpc.id
    cidr_block = var.CUSTOM_VPC_PRIVATE_SUBNET1_CIDR_BLOCK
    availability_zone = data.aws_availability_zones.available.names[0]
    

    tags ={

        Name = "${var.ENVIRONMENT}-custom-vpc-private-subnet-1"
    }
  
}

#Subnet Resource for private subnet 2
resource "aws_subnet" "custom_vpc_private_subnet_2" {
    vpc_id = aws_vpc.custom_vpc.id
    cidr_block = var.CUSTOM_VPC_PRIVATE_SUBNET2_CIDR_BLOCK
    availability_zone = data.aws_availability_zones.available.names[1]
    

    tags ={

        Name = "${var.ENVIRONMENT}-custom-vpc-private-subnet-2"
    }
  
}

#Internet gateway resource 

resource "aws_internet_gateway" "custom_vpc-igw" {
    vpc_id = aws_vpc.custom_vpc.id

    tags ={

        Name = "${var.ENVIRONMENT}-custom-vpc-igw"
    }
  
}

#Elastic IP resource
resource "aws_eip" "custom_nat_eip" {
    depends_on = [ aws_internet_gateway.custom_vpc-igw ]

}


#Nat gateway resource 
resource "aws_nat_gateway" "custom_vpc-nat-gateway" {
    allocation_id = aws_eip.custom_nat_eip.id
    subnet_id = aws_subnet.custom_vpc_public_subnet_1.id
    depends_on = [ aws_internet_gateway.custom_vpc-igw ]

  tags ={

        Name = "${var.ENVIRONMENT}-custom-vpc-nat-gateway"
    }  
  
}

#Route table for public subnets 

resource "aws_route_table" "custom-public" {
    vpc_id = aws_vpc.custom_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.custom_vpc-igw.id
    
    }

    tags ={

        Name = "${var.ENVIRONMENT}-custom-vpc-public-route"
    }  
  
}

#Route table for the private subnets 
resource "aws_route_table" "custom-private" {
    vpc_id = aws_vpc.custom_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.custom_vpc-nat-gateway.id
    
    }

    tags ={

        Name = "${var.ENVIRONMENT}-custom-vpc-private-route"
    }  
  
}

#Table association for the public subnet 1
resource "aws_route_table_association" "to_public_1" {
    subnet_id = aws_subnet.custom_vpc_public_subnet_1.id
    route_table_id = aws_route_table.custom-public.id
  
}

#Table association for the public subnet 2
resource "aws_route_table_association" "to_public_2" {
    subnet_id = aws_subnet.custom_vpc_public_subnet_2.id
    route_table_id = aws_route_table.custom-public.id
  
}


#Table association for the private subnet 1
resource "aws_route_table_association" "to_private_1" {
    subnet_id = aws_subnet.custom_vpc_private_subnet_1.id
    route_table_id = aws_route_table.custom-private.id
  
}


#Table association for the public subnet 2

resource "aws_route_table_association" "to_private_2" {
    subnet_id = aws_subnet.custom_vpc_private_subnet_2.id
    route_table_id = aws_route_table.custom-private.id
  
}

#This output the vpc ID
output "my_vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.custom_vpc.id
}


#This output the private subnet 1 id 
output "private_subnet1_id" {
  description = "Subnet ID"
  value       = aws_subnet.custom_vpc_private_subnet_1.id
}

#This output the private subnet 2 id 

output "private_subnet2_id" {
  description = "Subnet ID"
  value       = aws_subnet.custom_vpc_private_subnet_2.id
}


#This output the public subnet 1 id 

output "public_subnet1_id" {
  description = "Subnet ID"
  value       = aws_subnet.custom_vpc_public_subnet_1.id
}


#This output the private subnet 2 id 

output "public_subnet2_id" {
  description = "Subnet ID"
  value       = aws_subnet.custom_vpc_private_subnet_2.id
}