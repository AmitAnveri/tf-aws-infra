# Write output after infra setup
output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.main_igw.id
}

output "app_url" {
  value       = "http://${var.subdomain_prefix}.${var.domain_name}:${var.application_port}/"
  description = "URL to access the web application in the root context"
}