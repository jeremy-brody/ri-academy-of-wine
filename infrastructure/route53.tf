# Reference existing Route 53 hosted zone
data "aws_route53_zone" "main" {
  zone_id = var.hosted_zone_id
}

# App Runner custom domain association (using www subdomain)
resource "aws_apprunner_custom_domain_association" "webapp" {
  domain_name          = "www.${var.domain_name}"
  service_arn          = aws_apprunner_service.webapp.arn
  enable_www_subdomain = false
}

# Route 53 records for custom domain
# App Runner requires specific DNS records for domain validation
resource "aws_route53_record" "webapp_validation" {
  for_each = {
    for record in aws_apprunner_custom_domain_association.webapp.certificate_validation_records : record.name => {
      name   = record.name
      type   = record.type
      value  = record.value
    }
  }

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 300
}

# CNAME record pointing to App Runner (www subdomain)
resource "aws_route53_record" "webapp" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_apprunner_custom_domain_association.webapp.dns_target]

  depends_on = [aws_route53_record.webapp_validation]
}
