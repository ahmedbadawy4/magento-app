module "vpc" {
  source            = "./modules/vpc"
  AVAIALBILITY_ZONE = ["us-east-2a", "us-east-2b", "us-east-2c"]
  VPC_CIDR          = "10.0.0.0/16"
  SUBNET_CIDR       = "10.0.1.0/24"
}

module "ec2" {
  source = "./modules/ec2"
  ##depends_on            = [module.vpc]
  VARNISH_INSTANCE_TYPE = "t2.small"
  MAGENTO_INSTANCE_TYPE = "t2.small"
  SSH_KEY_NAME          = "Ahmed-key"
  MAGENTO_VOLUME_SIZE   = "28"
  VARNISH_VOLUME_SIZE   = "28"
  MAGENTO2_SG_ID        = module.vpc.magento2_sg_id
  MAIN_SUBNET           = module.vpc.main_subnet_id
}

module "alb" {
  source              = "./modules/alb"
  depends_on          = [module.vpc, module.ec2]
  allowed_cidr_blocks = "169.132.90.0/23"
  certificate_arn     = "arn:aws:iam::833915412828:server-certificate/abadawy"
  MAGENTO2_VPC_ID     = module.vpc.magento2_vpc_id
  VARNISH_SERVER_ID   = module.ec2.varnish_server_arn
  MAGENTO2_SERVER_ID  = module.ec2.magento2_server_arn
  MAIN_SUBNET         = module.vpc.main_subnet_id
}
