module "customvpc" {
    source = "../vpc"
    region = var.region
    ENVIRONMENT = var.ENVIRONMENT
  
}

resource "aws_db_subnet_group" "custom-rds-subnet-group" {
    name = "${var.ENVIRONMENT}-custom-db-snet"
    description = "Allowed subnet for db clusters"
    subnet_ids = [
        "${module.customvpc.private_subnet1_id}",
        "${module.customvpc.private_subnet2_id}"
    ]
    tags = {
        Name = "${var.ENVIRONMENT}_custom_db_subnet"
    }
}

resource "aws_security_group" "custom-rds-sg" {

    name = "${var.ENVIRONMENT}-levelup-rds-sg"
    description = "Created by custom"
    vpc_id = module.customvpc.my_vpc_id

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["${var.RDS_CIDR}"]

    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }

    tags = {
      Name = "${var.ENVIRONMENT}_custom-rds-sg"
    }
  
}

resource "aws_db_instance" "custom-rds" {
    identifier = "${var.ENVIRONMENT}-custom-rds"
    allocated_storage = var.CUSTOM_RDS_ALLOCATED_STORAGE
    storage_type = "gp2"
    engine = var.CUSTOM_RDS_ENGINE
    engine_version = var.CUSTOM_RDS_ENGINE_VERSION
    instance_class = var.DB_INSTANCE_CLASS
    backup_retention_period = var.BACKUP_RETENTION_PERIOD
    publicly_accessible = var.PUBLICLY_ACCESSIBLE
    username = var.CUSTOM_RDS_USERNAME
    password = var.CUSTOM_RDS_PASSWORD
    vpc_security_group_ids = [aws_security_group.custom-rds-sg.id]
    db_subnet_group_name = aws_db_subnet_group.custom-rds-subnet-group.name
    multi_az = "false"
  
}

output "rds_prod_endpoint" {
    value = aws_db_instance.custom-rds.endpoint
  
}