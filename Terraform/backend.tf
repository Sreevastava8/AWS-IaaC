terraform {
  backend "s3" {
    bucket       = "shopsphere-terraform-state-91827"
    key          = "terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}