output "cloudfront_domain" {
  value = module.cloudfront.cloudfront_domain
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "cloudfront_distribution_id" {
  value = module.cloudfront.cloudfront_distribution_id
}
