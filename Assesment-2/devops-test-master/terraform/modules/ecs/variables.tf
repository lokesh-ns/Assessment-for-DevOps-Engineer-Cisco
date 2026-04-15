variable "project"              { type = string }
variable "environment"          { type = string }
variable "aws_region"           { type = string }
variable "vpc_id"               { type = string }
variable "private_subnet_1_id"  { type = string }
variable "private_subnet_2_id"  { type = string }
variable "alb_sg_id"            { type = string }
variable "alb_target_group_arn" { type = string }
variable "ecr_repository_url"   { type = string }
variable "api_image_tag"        { type = string }
variable "redis_endpoint"       { type = string }
variable "redis_port"           { type = number }
variable "api_desired_count"    { 
    type = number 
    default = 2 
    }
variable "api_cpu"              { 
    type = number
    default = 512 
    }
variable "api_memory"           { 
    type = number

    default = 1024 
    }