# AWS Vars
variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "region" {}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

# Subnet Vars
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet" {
  default = "10.0.0.0/24"
}

# Main Vars
variable "zone" {
  default = "us-west-1a"
}

variable "my_key_name" {
  default = "ssh-key"
}

variable "ami" {
  default = "ami-73f7da13"
}

variable "instance_type" {
  default = "t2.micro"
}
