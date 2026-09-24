terraform {
  backend "s3" {
    bucket       = "terraform-state-443708727354"
    key          = "project-06/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}