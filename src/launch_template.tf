resource "aws_launch_template" "web_app_launch_template" {
  name          = var.launch_template_name
  image_id      = var.ami_id
  instance_type = var.instance_type

  key_name = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.application_sg.id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.web_app_instance_profile.name
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_type = var.volume_type
      volume_size = var.volume_size
    }
  }

  user_data = base64encode(<<EOF
#!/bin/bash
echo "DB_HOST=${aws_db_instance.rds_instance.endpoint}" >> /etc/environment
echo "DB_USERNAME=${var.db_username}" >> /etc/environment
echo "DB_PASSWORD=${var.db_password}" >> /etc/environment
echo "DB_NAME=${var.db_name}" >> /etc/environment
echo "AWS_S3_BUCKET=${aws_s3_bucket.app_images.bucket}" >> /etc/environment
echo "SNS_TOPIC_ARN=${aws_sns_topic.email_verification_topic.arn}" >> /etc/environment
source /etc/environment
sudo systemctl restart webapp.service

# Configure and start the CloudWatch Agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 \
-c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${replace(var.vpc_name, "_", "-")}-web_app_instance"
    }
  }
}
