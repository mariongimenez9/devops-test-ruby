variable "region" {}

variable azs {
    default = {
        "eu-west-1" = "eu-west-1a,eu-west-1b"
    }
}
variable "vpc_name" {}
variable "base_network" {}
variable "public_networks" {}
variable "private_networks" {}
variable "bucket" {}
