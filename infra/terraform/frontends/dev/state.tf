terraform {
    backend "s3" {
        bucket = "tfstateaircall"
        key    = "dev/front"
        region = "eu-west-1"
    }
}

data "terraform_remote_state" "vpc" {
    backend = "s3"
    config {
        bucket = "tfstateaircall"
        key    = "dev/vpc"
        region = "eu-west-1"
    }
}
