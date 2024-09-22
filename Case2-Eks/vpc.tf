#VPC declaration for the eks cluster and node

#module for the vpc
module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "5.13.0"

    name="vpc-module-demo"
    cidr = "10.0.0.0/16"

    azs =slice(data.aws_availability_zones.available.names, 0,2)
    private_subnets = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
    public_subnets = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]

    enable_nat_gateway = false
    enable_vpn_gateway = false

    tags ={
        Name = "${var.cluster-name}-vpc"
}

}