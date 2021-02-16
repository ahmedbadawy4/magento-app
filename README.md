# Overview
This is a technical guide to provision an infrastructure to host Magento 2 application on AWS.

## 📝 Table of Contents:

- [Prerequisites](#Prerequisites)
- [Setup AWS credentials](#Setup_AWS_credentials)
- [setup terraform](#setup_terraform)
- [Step-5 Get Started]()

## Prerequisites
- AWS account [Signup/Login](https://console.aws.amazon.com/console/home?nc2=h_ct&src=header-signin)


## Setup_AWS_credentials (Linux/mac OS):

1- Create a new user in the IAM Section on AWS [here](https://console.aws.amazon.com/iam/home?region=us-east-1#/users) and select "*Programmatic access*".

2- Either Attached the AdministratorAccess policy or add the new user to the admin group or add specific policies one by one.  

3- Download the credentials.csv file which contains the new user credentials.

4- Add AWS credentials in your local machine:

   - Setup AWS credential for Windows or Mac from [here](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html).   

  - Setup AWS credential for Linux:  ```mkdir -p ~/.aws/ && touch ~/.aws/credentials``` with the below syntax and add the **Access key ID** and **Secret access key**.
```bash
[default]
region = us-east-1
aws_access_key_id = AKI******************NU
aws_secret_access_key = FC*******************q27v

```
## setup_terraform:

### 2.a Install:

- Download Terraform `>= 0.12` [here](https://releases.hashicorp.com/terraform/) and follow the guide [here](https://www.terraform.io/intro/getting-started/install.html) on how to install Terraform on your specific system.
- Check terraform installation Run: `terraform version`

### 2.b initial configurations:

- Setup S3 bucket as a backend to terraform.tfstate file:
*IMPORTANT* make sure that the S3 bucket is not public!
*Setup S3 permission:*        Navigate to Permission > Bucker Policy  and add the below policy:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::<Account_ID>:user/<your_AWS_User_name>"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::<BUCKET_NAME>"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::<Account_ID>:user/<your_AWS_User_name>"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::<BUCKET_NAME>/*"
        }
    ]
}
```
- Add `S3 bucket name` and `path to terraform.tfstate` in `backend.tf` file:

```
terraform {
  backend "s3" {
    bucket = "<Bucket_NAME>"
    key    = "PATH/TO/terraform.tfstate"
    region = "<BUCKEt_REGION>"
  }
}
```