// Terraform build some stuff

variable "access_key" {}
variable "secret_key" {}
variable "region" {
   default = "us-east-1"
}

// defines the buckets where state and logs will be stored
variable "bucket_ID" {}
variable "state_file" {}
variable "amis" {
  type = "map"
  default = {
    us-east-1 = "ami-13be557e"
    us-west-2 = "ami-06b94666"
  }
}

output "ip" {
    value = "${aws_eip.ip.public_ip}"
}
output "ami_id" {
  value="${aws_instance.example.ami}"
}
