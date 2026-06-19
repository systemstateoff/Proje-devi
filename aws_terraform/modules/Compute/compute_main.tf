data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

# 1. ALB Security Group: Dış dünyadan gelen HTTP (Port 80) trafiğini kabul eder.
resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group-odev"
  vpc_id      = var.vpc_id
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

# 2. EC2 Security Group: Sadece ve sadece ALB'den gelen trafiği kabul eder.
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-private-security-group-odev"
  vpc_id      = var.vpc_id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Sadece üstteki ALB'ye izin veriyoruz
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Application Load Balancer (Public Subnetlerde durur)
resource "aws_lb" "web_alb" {
  name               = "odev-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids
}

# 4. ALB Target Group
resource "aws_lb_target_group" "web_tg" {
  name     = "odev-alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }
}

# 5. ALB Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# 6. EC2 Launch Template (İnternetsiz, Paket İndirmeyen Çözüm)
resource "aws_launch_template" "asg_template" {
  name_prefix   = "odev-ec2-template-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  network_interfaces {
    associate_public_ip_address = false # Public IP atanmaz, tamamen gizli
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  # Apache indirmek yerine Ubuntu içinde hazır kurulu gelen Python ile HTTP sunucusu ayağa kaldırıyoruz.
  user_data = base64encode(<<-EOF
              #!/bin/bash
              mkdir -p /var/www/html
              echo "<h1>Hello AWS - Multi-AZ ASG & ALB Basariyla Calisiyor!</h1>" > /var/www/html/index.html
              cd /var/www/html
              # Port 80 üzerinden internet gerektirmeden lokal web yayını başlatır:
              python3 -m http.server 80 &
              EOF
  )
}

# 7. Auto Scaling Group (Private Subnetlerde çalışır)
resource "aws_autoscaling_group" "web_asg" {
  desired_capacity    = 2
  max_size            = 2
  min_size            = 2
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [aws_lb_target_group.web_tg.arn]

  launch_template {
    id      = aws_launch_template.asg_template.id
    version = "$Latest"
  }
}