variable "VPC_CIDR" {
  description = "CIDR for vpc"
}
variable "SUBNET_CIDR1" {
  description = "subnet for the first Availability Zone"
}

variable "SUBNET_CIDR2" {
  description = "subnet for the second Availability Zone"
}

variable "az_1" {
  description = "Application Availability Zone 1 "
}

variable "az_2" {
  description = "Application Availability Zone 2 "
}