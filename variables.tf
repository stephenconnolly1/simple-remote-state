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
    us-east-1 = "ami-e13739f6" //Ubuntu Server 16.04 LTS (HVM),EBS General Purpose (SSD) Volume Type
    us-west-2 = "ami-b7a114d7" //
  }
}
variable "desktop_ip" {}
variable "key_name" {}
output "ip" {
    value = "${aws_eip.ip.public_ip}"
}
output "ami_id" {
  value="${aws_instance.docker_host.ami}"
}
