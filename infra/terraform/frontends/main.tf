
provider "aws" {
  region = "${var.region}"
}

data "aws_ami" "front_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.name_ami_filter}"]
  }
}

resource "aws_elb" "web" {
    name = "web${var.frontend_name}"
    subnets = ["${split(",",data.terraform_remote_state.vpc.public_subnets)}"]
    security_groups = ["${aws_security_group.elb.id}"]
    cross_zone_load_balancing = "true"
    internal = "false"
    listener {
        instance_port = "9292"
        instance_protocol = "tcp"
        lb_port = "9292"
        lb_protocol = "tcp"
    }
    health_check {
        healthy_threshold = "2"
        unhealthy_threshold = "2"
        timeout = "2"
        target = "HTTP:80/"
        interval = "5"
    }
    tags { Name = "web-${var.frontend_name}" }
}

data "template_file" "user_data" {
    template = "${file("../user_data.tpl")}"
    vars {
         env = "${var.env}"
    }
}

resource "aws_launch_configuration" "web" {
    image_id = "${data.aws_ami.front_ami.id}"
    name_prefix = "lc-web-${var.frontend_name}-"
    instance_type = "${var.web_instance_type}"
    key_name = "${var.key_name}"
    associate_public_ip_address = "true"
    security_groups = ["${aws_security_group.web.id}",
                       "${data.terraform_remote_state.vpc.sg_sshserver}"]
    user_data="${data.template_file.user_data.rendered}"
    iam_instance_profile = "${aws_iam_instance_profile.web.id}"
    lifecycle { create_before_destroy = true }
}

resource "aws_autoscaling_group" "web_asg" {
    name = "asg-${aws_launch_configuration.web.name}"
    launch_configuration = "${aws_launch_configuration.web.id}"
    availability_zones = ["${split(",",data.terraform_remote_state.vpc.azs)}"]
    vpc_zone_identifier = ["${split(",",data.terraform_remote_state.vpc.public_subnets)}"]
    load_balancers = ["${aws_elb.web.name}"]
    health_check_type = "${var.health_check_type}"
    health_check_grace_period = "${var.health_check_grace_period}"
    tag { key = "Name" value = "Web-${var.frontend_name}" propagate_at_launch = "true" }
    min_size = "${var.asg_min}"
    min_elb_capacity = "${var.asg_min}"
    max_size = "${var.asg_max}"
    desired_capacity = "${var.asg_desired}"
    lifecycle { create_before_destroy = true }
}


resource "aws_security_group" "web" {
    name = "sg_web_${var.backend_name}"
    description = "Allow traffic to web instances"
    vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
    ingress {
        from_port = "80"
        to_port = "80"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
       from_port = "9292"
       to_port = "9292"
       protocol = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
       from_port = "0"
       to_port = "0"
       protocol = "-1"
       cidr_blocks = ["0.0.0.0/0"]
    }
    tags { Name = "sg_web_${var.backend_name}"}
}

resource "aws_security_group" "elb" {
    name = "sg_elb_${var.backend_name}"
    description = "Allow traffic to ELB"
    vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
    ingress {
        from_port = "80"
        to_port = "80"
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
    }
    egress {
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
       from_port = "9292"
       to_port = "9292"
       protocol = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
       from_port = "0"
       to_port = "0"
       protocol = "-1"
       cidr_blocks = ["0.0.0.0/0"]
    }
    tags { Name = "sg_elb_${var.backend_name}"}
}


resource "aws_iam_role" "web" {
    name = "role_web_${var.backend_name}"
    path = "/"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "web" {
    name = "profile_web_${var.backend_name}"
    role = "${aws_iam_role.web.name}"
}

resource "aws_iam_policy" "webpolicy" {
  name        = "policy_${var.backend_name}"
  description = "Policy for front EC2"
  path        = "/"
  
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::${var.asset_bucket}/"
    },
    {
      "Effect": "Allow",
      "Action": "kms:*",
      "Resource": "arn:aws:kms:eu-west-1:575125281408:key/6e2eeeee-e185-4787-aec1-3e88f28d3f8e"
    }
  ]
}
  EOF
}

resource "aws_iam_policy_attachment" "attachment" {
  name       = "policy_attachment_${var.backend_name}"
  roles      = ["${aws_iam_role.web.name}"]
  policy_arn = "${aws_iam_policy.webpolicy.arn}"
}


output "sg_web" { value = "${aws_security_group.web.id}" }
output "web_profile" { value = "${aws_iam_instance_profile.web.id}" }
