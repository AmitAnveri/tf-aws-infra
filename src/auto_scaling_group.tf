resource "aws_autoscaling_group" "web_app_asg" {
  depends_on = [
    aws_db_instance.rds_instance, aws_secretsmanager_secret.db_credentials
  ]
  name                = "${var.scaling_policy_name}-asg"
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = [for subnet in aws_subnet.private_subnets : subnet.id]
  default_cooldown    = var.cooldown_period
  launch_template {
    id      = aws_launch_template.web_app_launch_template.id
    version = "$Latest"
  }

  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  target_group_arns         = [aws_lb_target_group.web_app_tg.arn]

  tag {
    key                 = "Name"
    value               = var.scaling_policy_name
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
