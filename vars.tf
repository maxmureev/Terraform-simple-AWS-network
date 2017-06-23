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

variable "my_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFFAEsu9b74YAkEHxfP3vpRaQBul0BPj6FrrDYPgNscPE7n8NbKUZs1FhrlkwqhKAaa9fTpG63D3XbzU7CaojtvXw6KcMdCGb3e4RlhxVqshM+PTrpFkQXSokyrhQSGjlj9n78zvHxUYD9ireshJnsRw5WTy+/pll441+ZCiH45xT0sAQ48oDs8OQXGIh37zeULSTV22qKLRYKoFBa9lrcJXYBCLUWebcosieufbcOiauebC+v06t7TRqSnIERjm6NnXf3v4dSwqDMONQBg2zv"
}
variable "ami" {
  default = "ami-73f7da13"
}

variable "instance_type" {
  default = "t2.micro"
}
