variable "project" {
  default = "mindmeld"
}

variable "environment" {
  default = "dev"
}

variable "vpc_cidr" {
  default = "12.0.0.0/16"
}

variable "azs" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  default = ["12.0.1.0/24", "12.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["12.0.3.0/24", "12.0.4.0/24"]
}

variable "aws_region" {
  default = "us-east-1"
}

variable "api_image_tag" {
  default = "latest"
}

variable "api_desired_count" {
  default = 2
}

variable "api_cpu" {
  default = 512
}

variable "api_memory" {
  default = 1024
}