terraform {
  backend "s3" {
    bucket = "ri-academy-of-wine-infrastructure-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
