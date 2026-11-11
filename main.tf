provider "aws" {
  region = "ap-southeast-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_security_group" "web_sg" {
  name = "terraform-nginx-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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

resource "aws_instance" "web_a" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  availability_zone      = "ap-southeast-2a"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data = <<-EOT
    #!/bin/bash
    apt update -y
    apt install -y nginx
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Hello from 2a - Terraform Nginx</h1>" > /var/www/html/index.html
  EOT
  tags = { Name = "terraform-nginx-2a" }
}

resource "aws_instance" "web_b" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  availability_zone      = "ap-southeast-2b"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data = <<-EOT
    #!/bin/bash
    apt update -y
    apt install -y nginx
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Hello from 2b - Terraform Nginx</h1>" > /var/www/html/index.html
  EOT
  tags = { Name = "terraform-nginx-2b" }
}

output "ip_2a" { value = aws_instance.web_a.public_ip }
output "ip_2b" { value = aws_instance.web_b.public_ip }
