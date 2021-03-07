data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "varnish_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.VARNISH_INSTANCE_TYPE
  key_name               = var.SSH_KEY_NAME
  subnet_id              = var.az_1_SUBNET
  vpc_security_group_ids = [var.MAGENTO2_SG_ID]
  user_data              = <<-EOF
              #!/bin/bash
              sudo apt update && apt upgrade -y
              apt install nginx varnish -y
              systemctl start varnish
              systemctl enable varnish
              systemctl status varnish
              systemctl start nginx
              systemctl enable nginx
              EOF
  root_block_device {
    volume_size           = var.VARNISH_VOLUME_SIZE
    delete_on_termination = "true"
  }
  tags = {
    Name = "abadawy-dev"
  }
}

resource "aws_instance" "magento2_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.MAGENTO_INSTANCE_TYPE
  key_name               = var.SSH_KEY_NAME
  subnet_id              = var.az_1_SUBNET
  vpc_security_group_ids = [var.MAGENTO2_SG_ID]
  user_data              = <<-EOF
              #!/bin/bash
              sudo apt update && apt upgrade -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo systemctl enable apache2
              sudo a2ensite magento2.conf
              sudo a2enmod rewrite
              sudo systemctl daemon-reload
              EOF
  root_block_device {
    volume_size           = var.MAGENTO_VOLUME_SIZE
    delete_on_termination = "true"
  }
  tags = {
    Name = "abadawy-dev"
  }
}