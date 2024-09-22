module "custom-vpc" {
    source = "../module/vpc"
    region = var.region
    ENVIRONMENT = var.ENVIRONMENT
  
}

module "custom-rds" {
    source = "../module/rds"
    region = var.region
    ENVIRONMENT = var.ENVIRONMENT
  
}

resource "aws_security_group" "custom-webservers-sg" {

    name = "${var.ENVIRONMENT}-levelup-rds-sg"
    description = "Created by custom"
    vpc_id = module.custom-vpc.my_vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.SSH_CIDR_WEB_SERVER}"]

    }

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

    tags = {
      Name = "${var.ENVIRONMENT}_custom-webservers-sg"
    }
  
}

resource "aws_key_pair" "custom_key" {
    key_name = "custom_key"
    public_key = file(var.public_key_path)
  
}

resource "aws_launch_configuration" "lauch-config-webservers" {
    name = "launch_config_webservers"
    user_data = "#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYIP=`ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'Hello Team\nThis is my IP: '$MYIP > /var/www/html/index.html"
    image_id = lookup(var.AMIS,var.region)
    instance_type = var.INSTANCE_TYPE
    security_groups = [aws_security_group.custom-webservers-sg.id]
    key_name = aws_key_pair.custom_key.key_name


    root_block_device {
      volume_type = "gp2"
      volume_size = "20"
    }
  
}

resource "aws_autoscaling_group" "levelup_webserver" {
    name ="levelup_webservers"
    max_size = 2
    min_size = 1
    health_check_grace_period = 30
    health_check_type = "EC2"
    desired_capacity = 1
    force_delete = true
    launch_configuration = aws_launch_configuration.lauch-config-webservers.name
    vpc_zone_identifier = ["${module.custom-vpc.public_subnet1_id}","${module.custom-vpc.public_subnet1_id}"]
    target_group_arns = [aws_lb_target_group.load-balancer-target-group.arn]
  
}

resource "aws_lb" "custom-load-balancer" {
    internal = false
    name = "${var.ENVIRONMENT}-custom-lb"
    load_balancer_type = "application"
    security_groups = []
    subnets = ["${module.custom-vpc.public_subnet1_id}","${module.custom-vpc.public_subnet1_id}"]
  
}

resource "aws_lb_target_group" "load-balancer-target-group" {
    name ="load-balancer-target-group"
    port = 80
    protocol = "HTTP"
    vpc_id = module.custom-vpc.my_vpc_id
  
}

resource "aws_lb_listener" "webserver_listener" {
    load_balancer_arn = aws_lb.custom-load-balancer.arn
    port = "80"
    protocol = "HTTP"

    default_action {
      target_group_arn = aws_lb_target_group.load-balancer-target-group.arn
      type = "forward"
    }
}

output "load_balancer" {
    value = aws_lb.custom-load-balancer.dns_name
  
}