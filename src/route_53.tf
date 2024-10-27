# Route 53 A record for the EC2 instance
resource "aws_route53_record" "app_a_record" {
  zone_id = var.zone_id
  name    = "${var.subdomain_prefix}.${var.domain_name}"
  type    = "A"
  ttl = 300

  # Point to the public IP of the EC2 instance
  records = [aws_instance.web_app_instance.public_ip]
}
