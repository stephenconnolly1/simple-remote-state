# Simple terraform example showing remote state

### To create the bucket

Use the remote-state-S3-bucket repository to create the S3 bucket for this project.

The code will output the name of the S3 bucket in which to store your state.

You need to update the `configure-remote-state.bat` file so that Terraform can  
 knows where remote state is to be stored. Update the Bucket and Key values as necessary.

 Open a command prompt and run

    configure-remote-state.bat

You will also need to provide a `terraform.tfvars` file in the
folder that defines values for the secrets associated with the IAM user you are using and the
location of the S3 bucket and the path to the state file within that bucket.

    access_key = "<KEY_ID>"
    secret_key = "<SECRET_KEY>"
    bucket_ID = "<Full name of the S3 bucket>"
    state_file = "<Folder>/terraform.tfstate"

Open a command prompt and run

    terraform plan

Then once you are happy that all variables are populated correctly and
the the plan goes through successfully

    terraform apply

Make a note of the output, as this contains the name of the bucket ID you will need
to pass into the configuration of your main terraform project so that it can store state in the S3 bucket.
