output "varnish_public_IP" {
  value = module.ec2.VARNISH_public_ip
}


output "magento2_public_IP" {
  value = module.ec2.MAGENTO2_public_ip
}