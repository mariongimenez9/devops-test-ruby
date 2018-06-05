region	            = "eu-west-1"

frontend_name	    = "testAircallprod"

web_instance_type   = "t2.micro"
key_name	    = "testAircall"

asg_desired	    = "2"
asg_max	            = "4"
asg_min	            = "2"
health_check_type   = "ELB"
health_check_grace_period = "300"
backend_name        = "aircallprod"
env                 = "development"
name_ami_filter     = "testAircall-*"
bucket              = "testAircallprod"
