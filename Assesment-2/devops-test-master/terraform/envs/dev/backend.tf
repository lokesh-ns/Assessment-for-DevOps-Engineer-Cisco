terraform {
  backend "s3" {
    bucket       = "lokesh-s3-terraform-backend-001"
    key          = "terraform/state"
    use_lockfile = true
    region       = "us-east-1"
    encrypt = true
  }
}
