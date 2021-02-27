module "vpc" {
  source            = "./modules/vpc"
  AVAIALBILITY_ZONE = "us-east-2a"
  VPC_CIDR          = "10.0.0.0/16"
  SUBNET_CIDR       = "10.0.1.0/24"
}

module "ec2" {
  source                = "./modules/ec2"
  VARNISH_INSTANCE_TYPE = "t2.small"
  MAGENTO_INSTANCE_TYPE = "t2.small"
  SSH_KEY_NAME          = "Ahmed-key"
  MAGENTO_VOLUME_SIZE   = "28"
  VARNISH_VOLUME_SIZE   = "28"
  MAGENTO2_SG_ID        = module.vpc.magento2_sg_id
  MAIN_SUBNET           = module.vpc.main_subnet_id
}