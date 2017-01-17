// Terraform build some stuff

provider "aws" {
  access_key ="${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "example" {
  ami           = "${lookup(var.amis,var.region)}"
  instance_type = "t2.micro"
}
resource "aws_eip" "ip" {
    instance = "${aws_instance.example.id}"
}
