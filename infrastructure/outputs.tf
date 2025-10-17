output "apprunner_service_id" {
  description = "The ID of the App Runner service"
  value       = aws_apprunner_service.webapp.service_id
}

output "apprunner_service_arn" {
  description = "The ARN of the App Runner service"
  value       = aws_apprunner_service.webapp.arn
}

output "apprunner_service_url" {
  description = "The default App Runner service URL"
  value       = aws_apprunner_service.webapp.service_url
}

output "apprunner_service_status" {
  description = "The status of the App Runner service"
  value       = aws_apprunner_service.webapp.status
}

output "custom_domain" {
  description = "The custom domain configured for the App Runner service"
  value       = var.domain_name
}

output "custom_domain_dns_target" {
  description = "The DNS target for the custom domain"
  value       = aws_apprunner_custom_domain_association.webapp.dns_target
}

output "custom_domain_status" {
  description = "The status of the custom domain association"
  value       = aws_apprunner_custom_domain_association.webapp.status
}

output "instance_role_arn" {
  description = "The ARN of the App Runner instance role"
  value       = aws_iam_role.apprunner_instance_role.arn
}

output "ecr_access_role_arn" {
  description = "The ARN of the App Runner ECR access role"
  value       = aws_iam_role.apprunner_ecr_access_role.arn
}
