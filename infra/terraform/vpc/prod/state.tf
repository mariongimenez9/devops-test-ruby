terraform {
    backend "s3" {
        bucket = "tfstateaircall"
        key    = "prod/vpc"
        region = "eu-west-1"
    }
}

