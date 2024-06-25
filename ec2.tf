resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" 
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "WebServer"
  }

  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd php
                systemctl start httpd
                systemctl enable httpd
                echo "<?php phpinfo(); ?>" > /var/www/html/index.php
                EOF
}

resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.public.id
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name = "WebServer"
  }

  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd php
                systemctl start httpd
                systemctl enable httpd
                echo "<?php phpinfo(); ?>" > /var/www/html/index.php
                EOF
}
