terraform {
  backend "s3" {
    bucket = "abadawy-dev"
    key    = "magento2-app/terraform.tfstate"
    region = "us-east-1"
    encrypt = "true"
    profile = "ahmed"
  }
}