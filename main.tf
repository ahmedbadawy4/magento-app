module "vpc" {
  source       = "./modules/vpc"
  az_1         = "us-east-2a"
  az_2         = "us-east-2b"
  VPC_CIDR     = "10.0.0.0/16"
  SUBNET_CIDR1 = "10.0.1.0/24"
  SUBNET_CIDR2 = "10.0.2.0/24"
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
  az_1_SUBNET           = module.vpc.az_1_subnet_id
}

module "alb" {
  source              = "./modules/alb"
  depends_on          = [module.vpc, module.ec2]
  allowed_cidr_blocks = "169.132.90.0/23"
  certificate_arn     = "arn:aws:iam::833915412828:server-certificate/abadawy"
  MAGENTO2_VPC_ID     = module.vpc.magento2_vpc_id
  VARNISH_SERVER_ID   = module.ec2.varnish_server_arn
  MAGENTO2_SERVER_ID  = module.ec2.magento2_server_arn
  az_1_SUBNET         = module.vpc.az_1_subnet_id
  az_2_SUBNET         = module.vpc.az_2_subnet_id
}
