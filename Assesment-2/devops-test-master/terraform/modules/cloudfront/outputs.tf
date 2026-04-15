variable "project"      { type = string }
variable "environment"  { type = string }
variable "alb_dns_name" { type = string }
output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.this.id
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.this.domain_name
}