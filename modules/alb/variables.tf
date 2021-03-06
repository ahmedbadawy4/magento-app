
variable "allowed_cidr_blocks" {
  description = "Allowed Ips to access application"
}

variable "MAGENTO2_VPC_ID" {
  description = "main vpc id"
}

variable "VARNISH_SERVER_ID" {
  description = "varnish instance id"
}

variable "MAGENTO2_SERVER_ID" {
  description = "magento2 instance id"
}

variable "certificate_arn" {
  description = "ssh certificate arn"
}

variable "MAIN_SUBNET" {
  description = "main subnet"
}