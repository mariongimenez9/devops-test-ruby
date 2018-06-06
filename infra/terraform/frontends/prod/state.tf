terraform {
    backend "s3" {
        bucket = "tfstateaircall"
        key    = "prod/front"
        region = "eu-west-1"
    }
}

data "terraform_remote_state" "vpc" {
    backend = "s3"
    config {
        bucket = "tfstateaircall"
        key    = "prod/vpc"
        region = "eu-west-1"
    }
}
