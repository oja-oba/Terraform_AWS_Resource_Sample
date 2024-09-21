resource "aws_security_group" "custom-alb-security" {
    tags = {
      Name = "${var.ENVIRONMENT}-custom-alb-sg"
    }

    name = "${var.ENVIRONMENT}-custom-alb-sg"
    description = "security group for the alb"
    vpc_id = module.custom-vpc.my_vpc_id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

     ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        
    }

     egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        
    }
}