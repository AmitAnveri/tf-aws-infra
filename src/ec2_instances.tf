resource "aws_instance" "web_app_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.application_sg.id]
  subnet_id              = aws_subnet.public_subnets[0].id

  root_block_device {
    volume_type = var.volume_type
    volume_size = var.volume_size
  }

  associate_public_ip_address = true
  key_name                    = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    echo "DB_HOST=${aws_db_instance.rds_instance.endpoint}" >> /etc/environment
    echo "DB_USERNAME=${var.db_username}" >> /etc/environment
    echo "DB_PASSWORD=${var.db_password}" >> /etc/environment
    echo "DB_NAME=${var.db_name}" >> /etc/environment
    source /etc/environment
    sudo systemctl restart webapp.service
  EOF

  tags = {
    Name = "${var.vpc_name}_web_app_instance"
  }
}
