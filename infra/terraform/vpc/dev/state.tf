terraform {
    backend "s3" {
        bucket = "tfstateaircall"
        key    = "dev/vpc"
        region = "eu-west-1"
    }
}

