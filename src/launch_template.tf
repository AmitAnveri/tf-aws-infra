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
      kms_key_id  = aws_kms_key.ec2_encryption_key.arn
      encrypted   = true
    }
  }

  user_data = base64encode(<<EOF
#!/bin/bash

sudo apt update -y
sudo apt install -y unzip curl
sudo apt install -y jq

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

SECRET=$(aws secretsmanager get-secret-value --secret-id ${aws_secretsmanager_secret.db_credentials.id} --query 'SecretString' --output text)

DB_HOST=$(echo $SECRET | jq -r '.DB_HOST')
DB_PORT=$(echo $SECRET | jq -r '.DB_PORT')
DB_NAME=$(echo $SECRET | jq -r '.DB_NAME')
DB_USERNAME=$(echo $SECRET | jq -r '.DB_USERNAME')
DB_PASSWORD=$(echo $SECRET | jq -r '.DB_PASSWORD')

export DB_HOST DB_PORT DB_NAME DB_USERNAME DB_PASSWORD

echo "DB_HOST=$DB_HOST" >> /etc/environment
echo "DB_PORT=$DB_PORT" >> /etc/environment
echo "DB_NAME=$DB_NAME" >> /etc/environment
echo "DB_USERNAME=$DB_USERNAME" >> /etc/environment
echo "DB_PASSWORD=$DB_PASSWORD" >> /etc/environment
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
