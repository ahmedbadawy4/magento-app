output "main_subnet_id" {
  value       = aws_subnet.magento2.id
  description = "main subnet id"
}

output "magento2_sg_id" {
  value = aws_security_group.magento2.id
}


