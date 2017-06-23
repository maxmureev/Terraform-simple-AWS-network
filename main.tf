# Create Public SSH Key
resource "aws_key_pair" "key_name" {
  key_name   = "${var.my_key_name}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFFAEsu9b74YAkEHxfP3vpRaQBul0BPj6FrrDYPgNscPE7n8NbKUZs1FhrlkwqhKAaa9fTpG63D3XbzU7CaojtvXw6KcMdCGb3e4RlhxVqshM+PTrpFkQXSokyrhQSGjlj9n78zvHxUYD9ireshJnsRw5WTy+ilLpAc90zepXxJW5YZOGX3dDtTQ2BXhjbdV/0Ww1icTzw/pll441+ZCiH45xT0sAQ48oDs8OQXGIh37zeULSTV22qKLRYKoFBa9lrcJXbr+zq2NUXViEJ8wPFceI20l6bbhOr4RW9+v06t7TRqSnIERjm6NnXf3v4dSwqDMONQBg2zv+DiRO1l8B3"
}

# Create VPC
resource "aws_vpc" "vpc_name" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "my-vpc-name"
  }
}

# Create Subnet
resource "aws_subnet" "subnet_name" {
  vpc_id            = "${aws_vpc.vpc_name.id}"
  cidr_block        = "${var.subnet}"
  availability_zone = "${var.zone}"

  tags = {
    Name = "my-subnet-name"
  }
}

# Create Route Table
resource "aws_route_table" "rt_name" {
  vpc_id = "${aws_vpc.vpc_name.id}"

  tags {
    Name = "my-route-table-name"
  }
}

# Create Route To The Internet
resource "aws_route" "route_name" {
  route_table_id         = "${aws_route_table.rt_name.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw_name.id}"
}

# Associate The Route Table To Subnet
resource "aws_route_table_association" "rta_name" {
  subnet_id      = "${aws_subnet.subnet_name.id}"
  route_table_id = "${aws_route_table.rt_name.id}"
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw_name" {
  vpc_id = "${aws_vpc.vpc_name.id}"

  tags {
    Name = "my-igw-name"
  }
}

# Create Security Group
resource "aws_security_group" "sg_name" {
  name        = "my-sg"
  description = "Allow ping, ssh and output traffic"
  vpc_id      = "${aws_vpc.vpc_name.id}"

  tags {
    Name = "my-security-group-name"
  }

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Ping
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow All Output Traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Public Elastic IP
resource "aws_eip" "eip_name" {
  instance = "${aws_instance.instance_name.id}"
  vpc      = true
}

# Create Instance
resource "aws_instance" "instance_name" {
  ami                    = "${var.ami}"
  availability_zone      = "${var.zone}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.my_key_name}"
  vpc_security_group_ids = ["${aws_security_group.sg_name.id}"]
  subnet_id              = "${aws_subnet.subnet_name.id}"

  associate_public_ip_address = true
  source_dest_check           = false

  root_block_device {
    volume_size = "30"
    volume_type = "gp2"
  }

  tags {
    Name = "my-instance-name"
  }
}

# Output Elastic IP
output "instance_public_ip" {
  value = "${aws_eip.eip_name.public_ip}"
}
