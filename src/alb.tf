resource "aws_lb" "web_app_lb" {
  name               = "${replace(var.vpc_name, "_", "-")}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sg.id]
  subnets            = [for subnet in aws_subnet.public_subnets : subnet.id]

  tags = {
    Name = "${replace(var.vpc_name, "_", "-")}-alb"
  }
}

resource "aws_lb_target_group" "web_app_tg" {
  name     = "${replace(var.vpc_name, "_", "-")}-tg"
  port     = var.application_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id

  health_check {
    path                = "/healthz"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${replace(var.vpc_name, "_", "-")}-tg"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.web_app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_app_tg.arn
  }
}
