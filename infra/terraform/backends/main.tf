terraform {
    backend "s3" {
        bucket = "testaircalldev"
        key    = "test/backends"
        region = "eu-west-1"
    }
}

data "terraform_remote_state" "vpc" {
    backend = "s3"
    config {
        bucket = "testaircalldev"
        key    = "test/vpc"
        region = "eu-west-1"
    }
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_db_subnet_group" "subnet_group_mysql" {
  name        = "${var.name_prefix}"
  description = "${var.db_identifier} Subnet Group"
  subnet_ids  = ["${var.subnets}"]

  tags {
    Name        = "${var.name_prefix}"
    Application = "${var.application}"
    Environment = "${var.env}"
  }
}

resource "aws_db_instance" "mysql" {
  identifier                 = "${var.name_prefix}"
  allocated_storage          = "${var.db_allocated_storage}"
  storage_type               = "${var.db_storage_type}"
  engine                     = "${var.db_engine}"
  engine_version             = "${var.db_engine_version}"
  instance_class             = "${var.db_instance_class}"
  username                   = "${var.db_username}"
  password                   = "${var.db_password}"
  db_subnet_group_name       = "${aws_db_subnet_group.subnet_group_mysql.id}"
  vpc_security_group_ids     = ["${var.security_groups}"]
  parameter_group_name       = "${aws_db_parameter_group.main.name}"

  tags {
    Name        = "${var.name_resource}"
    Environment = "${var.environment}"
  }
}

output "mysql" { value = "${aws_db_instance.mysql.name}" }
