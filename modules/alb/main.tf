resource "aws_security_group" "alb" {
  name        = "magento_alb_sg"
  description = "Load balancer security group"
  vpc_id      = var.MAGENTO2_VPC_ID

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr_blocks]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr_blocks]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "magento2-alb-security-group"
  }
}

resource "aws_alb" "magento2" {
  name            = "magento2"
  security_groups = [aws_security_group.alb.id]
  subnets         = [var.az_1_SUBNET, var.az_2_SUBNET]
  tags = {
    "Name" = "magento2_alb"
  }
}

resource "aws_alb_target_group" "magento2" {
  name        = "magento2"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.MAGENTO2_VPC_ID
  target_type = "instance"
  stickiness {
    type = "lb_cookie"
  }
  #  health_check {
  #    path = "/"
  #    port = 80
  #  }
}

resource "aws_alb_target_group" "varnish" {
  name        = "varnish"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.MAGENTO2_VPC_ID
  target_type = "instance"
  stickiness {
    type = "lb_cookie"
  }
  #  health_check {
  #    path = "/"
  #    port = 80
  #  }
}

resource "aws_alb_listener_rule" "varnish" {
  depends_on   = [aws_alb_target_group.varnish]
  listener_arn = aws_alb_listener.listener_https.arn
  #priority     = "${var.priority}"   
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.varnish.id
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}



resource "aws_alb_listener_rule" "magento2" {
  depends_on   = [aws_alb_target_group.magento2]
  listener_arn = aws_alb_listener.listener_https.arn
  #priority     = "${var.priority}"   
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.magento2.id
  }
  condition {
    path_pattern {
      values = ["/static/*", "/media/*"]
    }
  }
}


resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = aws_alb.magento2.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "listener_https" {
  load_balancer_arn = aws_alb.magento2.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn
  default_action {
    target_group_arn = aws_alb_target_group.varnish.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "magento2" {
  target_group_arn = aws_alb_target_group.magento2.arn
  target_id        = var.MAGENTO2_SERVER_ID
  port             = 80
}
resource "aws_lb_target_group_attachment" "varnish" {
  target_group_arn = aws_alb_target_group.varnish.arn
  target_id        = var.VARNISH_SERVER_ID
  port             = 80
}