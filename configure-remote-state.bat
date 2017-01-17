@echo off
rem commands to perform the initial configuration the AWS S3 bucket and key
rem for TF remote state storage

rem Remote state config is a one-time thing so we don't define in the main code.

rem The secrets are not provided here. They are pulled in from the default
rem configurations of the AWS CLI - see
rem NB you have to set the region. It won't get picked up from the AWS CLI default region

rem configure these values to be the same as those in your .tfvars file

terraform remote config   ^
  -backend=s3   ^
  -backend-config="bucket=tf-remote-state-apollo-dev-1" ^
  -backend-config="key=tutorial1/terraform.tfstate" ^
  -backend-config="region=us-east-1"
