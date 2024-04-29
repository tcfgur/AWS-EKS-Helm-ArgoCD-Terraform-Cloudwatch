terraform {
  backend "s3" {
    bucket = "backend-guardian-project"
    key    = "terraform/terraform.tfstate"
    region = "eu-central-1"
  }
}
