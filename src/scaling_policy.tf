resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up_policy"
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_down_policy"
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
}
