# Aircall.io - DevOps technical test

This test is a part of our hiring process at Aircall for [DevOps positions](https://aircall.io/jobs#SystemAdministrator). It should take you between 3 and 6 hours depending on your experience.

__Feel free to apply! Drop us a line with your Linkedin/Github/Twitter/AnySocialProfileWhereYouAreActive at jobs@aircall.io__


## Summary

The purpose of the test is to reproduce one of our typical use case on the DevOps part of Aircall: __deployment__!

The story is the following:

Our backend team just developed a new service in order to make custom integrations for special customers. We need to deploy this service on one different virtual context for each customer, with a reproducible process.

It's 9AM in the office and first calls are coming in!


## Instructions

In this repository, you'll find a simple Rails project with one model. Your goal is to set up the web server using requirements below. The web server should be reachable from a public IP address.

### Technical stack

Find below the technical requirements for your virtual context.

Ruby version:
- 2.3

Rails version:
- 4.2.1

System dependencies:
- ruby (with bundler)
- nodejs
- mysql
- nginx
- libxslt-dev libxml2-dev zlib1g-dev libmysqlclient-dev

### Configuration

Find below the files you might need to modify/use in order to configure the launch of the application.

- config/environment.yml
- config/database.yml
- config/puma/*.rb
- config/nginx/server.conf

### Deployment
_Update 'production' to 'development' if you want to test locally_

Find below the commands you need to launch in order to deploy this application.

App dependencies:
- bundle install
- RACK_ENV=production RAILS_ENV=production rake assets:precompile

Database creation:
- RACK_ENV=production RAILS_ENV=production rake db:create

Database initialization:
- RACK_ENV=production RAILS_ENV=production rake db:migrate

Web server initialization:
- RACK_ENV=production RAILS_ENV=production bundle exec puma

Deploying the application

If you want to use this demo in your environment, you can clone it (or even fork it). You will need to do some reconfiguration on your account.

Configuration of terraform

First, you need to create a bucket to store your tfstates:

aws s3 mb s3://my-state-bucket
Then go to the terraform directory and edit the state configurations for the three terraform stacks:

terraform/vpc/main.tf
terraform/frontends/maint.tf
In these files, you need to update the bucket key for the terraform configuration:

terraform {
    backend "s3" {
        bucket = "my-state-bucket"
        key    = "demo/vpc"
        region = "eu-west-1"
    }
}
You then need to update data sources for cross-stack references in files:

terraform/frontends/$ENV/main.tf
In both, you need to modify the vpc data source (to access outputs from the vpc stack):

data "terraform_remote_state" "vpc" {
    backend = "s3"
    config {
        bucket = "my-state-bucket"
        key    = "test/vpc"
        region = "${var.region}"
    }
}

Deploy the VPC

Go to the terraform/vpc directory and initialize the terraform setup:

terraform init ..
Then you can see what resources terraform will create and apply

terraform plan ..
terraform apply ..

To deploy frontends, we need to use Packer to create an AMI with the code of the application. First, you need to go to the packer directory and configure Packer to use a VPC and subnet you own. You can do this by modifying the build_vpc and build_subnet in the vars/travis.json file:

"variables": {
        "build_subnet"         : "subnet-8b916cd1",
        "build_vpc"            : "vpc-a881fcce",
        "git_id"               : "build",
        "instance_type"        : "t2.micro",
        "region"               : "eu-west-1",
        "source_ami"           : "ami-58d7e821",
        "ssh_username"         : "ubuntu"
},

For the VPC and subnet, you can either use the one you created with terraform or use a different build VPC (which could be your default VPC for instance).

You can now build your AMI:

packer build template.json
Once your AMI is built, you can deploy the frontends of the application. Go to the terraform/frontends/"ENV" directory.
 You can now deploy your frontends using the AMI you built with packer.

terraform init ..
terraform plan ..
terraform apply ..
