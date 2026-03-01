resource "aws_key_pair" "devops_key" {
  key_name   = var.key_name
  public_key = file("~/.ssh/id_rsa.pub")
}

# ----------------------------
# Security Group
# ----------------------------
resource "aws_security_group" "spotify_sg" {
  name = "spotify-devops-sg"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Spotify App"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Grafana"
    from_port   = 3000
    to_port     = 3000
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

# ----------------------------
# EC2 Instance
# ----------------------------
resource "aws_instance" "spotify_server" {

  ami           = "ami-0f58b397bc5c1f2e8" # Ubuntu 22.04 Mumbai
  instance_type = var.instance_type
  key_name      = aws_key_pair.devops_key.key_name

  vpc_security_group_ids = [
    aws_security_group.spotify_sg.id
  ]

  tags = {
    Name = "Spotify-DevOps-Server"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install docker.io -y
              usermod -aG docker ubuntu
              systemctl enable docker
              systemctl start docker
              EOF
}