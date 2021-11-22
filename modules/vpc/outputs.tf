output "az_1_subnet_id" {
  value       = aws_subnet.magento2_1.id
  description = "az 1 subnet id"
}

output "az_2_subnet_id" {
  value       = aws_subnet.magento2_2.id
  description = "az 2 subnet id"
}

output "magento2_sg_id" {
  value = aws_security_group.magento2.id
}


output "magento2_vpc_id" {
  value = aws_vpc.magento2.id
}