resource "aws_route53_record" "web_app_alias" {
  zone_id = var.zone_id
  name    = var.subdomain_prefix
  type    = "A"

  alias {
    name                   = aws_lb.web_app_lb.dns_name
    zone_id                = aws_lb.web_app_lb.zone_id
    evaluate_target_health = true
  }
}
