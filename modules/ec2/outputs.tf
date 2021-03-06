output "VARNISH_public_ip" {
  value = aws_instance.varnish_server.public_ip
}
output "MAGENTO2_public_ip" {
  value = aws_instance.magento2_server.public_ip
}

output "varnish_server_arn" {
  value = aws_instance.varnish_server.id
}

output "magento2_server_arn" {
  value = aws_instance.magento2_server.id
}