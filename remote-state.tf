
data "terraform_remote_state" "remote-state" {
    backend = "s3"
    config {
        bucket = "${var.bucket_ID}"
        key = "${var.state_file}"
        region = "${var.region}"
        access_key="${var.access_key}"
        secret_key="${var.secret_key}"
    }
}

output "remote_state_file" {
  value="${data.terraform_remote_state.remote-state.config.bucket}/${data.terraform_remote_state.remote-state.config.key}"
}
