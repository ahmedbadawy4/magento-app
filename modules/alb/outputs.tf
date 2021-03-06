output "alb_dns_name" {
  value       = aws_alb.magento2.dns_name
  description = "alb url"
}