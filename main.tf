// Terraform build some stuff

provider "aws" {
  access_key ="${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

# Create a VPC to launch our instances into
resource "aws_vpc" "vpc_remote_state" {
  cidr_block = "10.0.0.0/16"
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.vpc_remote_state.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw_remote_state.id}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "private" {
  vpc_id                  = "${aws_vpc.vpc_remote_state.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}
# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "gw_remote_state" {
  vpc_id = "${aws_vpc.vpc_remote_state.id}"
}

# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "elb-remote-state" {
  name        = "elb-remote-state"
  description = "Created by Terraform"
  vpc_id      = "${aws_vpc.vpc_remote_state.id}"

  # HTTP access from specific range
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.desktop_ip}"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "internal" {
  name        = "remote_state_internal"
  description = "Internal access and SSH from anywhere"
  vpc_id      = "${aws_vpc.vpc_remote_state.id}"

  # SSH access from specific range
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.desktop_ip}"]
  }

  # HTTP access only from the VPC or the ELB
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.desktop_ip}"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*# Render a part using a `template_file`
data "template_file" "cloud-init" {
  template = "${file("${path.module}/cloud-init.sh")}"
}

# Render a multi-part cloudinit config making use of the part
# above, and other source files
data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false

  # Setup cloud-init script
  part {
    filename     = "cloud-init.sh"
    content_type = "text/part-handler"
    content      = "${data.template_file.cloud-init.rendered}"
  }
}*/

resource "aws_instance" "docker_host" {
  ami           = "${lookup(var.amis,var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.private.id}"
  vpc_security_group_ids = ["${aws_security_group.internal.id}"]
  key_name = "${var.key_name}"
  user_data     = "${file("${path.module}/cloud-init-script.sh")}"
}

resource "aws_eip" "ip" {
    instance = "${aws_instance.docker_host.id}"
}
