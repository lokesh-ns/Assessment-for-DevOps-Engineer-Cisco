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