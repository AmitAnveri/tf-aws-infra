resource "aws_autoscaling_group" "web_app_asg" {
  desired_capacity    = 3
  max_size            = 5
  min_size            = 3
  vpc_zone_identifier = [for subnet in aws_subnet.private_subnets : subnet.id]
  launch_template {
    id      = aws_launch_template.web_app_launch_template.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300
  target_group_arns = [aws_lb_target_group.web_app_tg.arn]

  tag {
    key                 = "Name"
    value               = "csye6225_asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
