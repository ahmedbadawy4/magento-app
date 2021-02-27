variable "VARNISH_INSTANCE_TYPE" {
  description = "instance_type"
}

variable "MAGENTO_INSTANCE_TYPE" {
  description = "instance_type"
}

variable "SSH_KEY_NAME" {
  description = "ssh key_name"
}

variable "MAGENTO_VOLUME_SIZE" {
  description = "root volume size"
}

variable "VARNISH_VOLUME_SIZE" {
  description = "root volume size"
}

variable "MAGENTO2_SG_ID" {
  description = "main SG for all ec2"
}

variable "MAIN_SUBNET" {
  description = "main subnet"
}