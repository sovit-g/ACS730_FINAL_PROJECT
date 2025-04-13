terraform {
  backend "s3" {
    bucket = "acs730-final-group-project-bucket"
    key    = "prod/webserver/terraform.tfstate"
    region = "us-east-1"
  }
}