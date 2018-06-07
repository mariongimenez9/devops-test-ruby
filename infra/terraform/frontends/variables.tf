variable "region" {}

variable "frontend_name" {}

variable "web_instance_type" {}
variable "key_name" {}

variable "health_check_type" {}

variable "asg_desired" {}
variable "asg_max" {}
variable "asg_min" {}
variable "health_check_grace_period" {}

variable "name_ami_filter" {}
variable "backend_name" {}
variable "env" {}
variable "db_allocated_storage" {}
variable "db_storage_type" {}
variable "db_instance_class" {}
variable "db_username" {}
variable "db_password" {}
variable "db_engine" {}
variable "asset_bucket" {}
variable "kms_key_id" {}
