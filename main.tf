terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1" # Change to your preferred region ** HAS TO MATCH AWS CLI CREDENTIALS REGION
}

resource "aws_security_group" "minecraft_sg" {
  name_prefix = "minecraft_sg"

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 20
    to_port     = 20
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "minecraft-sg"
  }
}

resource "aws_instance" "minecraft_server" {
  ami                         = "ami-04b70fa74e45c3917" # Canonical, Ubuntu, 24.04 LTS, amd64 noble image build on 2024-04-23 (for us-east-1)
  instance_type               = "t2.medium"
  key_name                    = "my-minecraft-key"
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              # Update package repository
              sudo apt-get update -y
              # Install Docker
              sudo apt-get install -y docker.io
              # Enable Docker to start on boot
              sudo systemctl enable docker
              # Pull the Minecraft Docker image
              sudo docker pull itzg/minecraft-server
              # Create a systemd service for Minecraft
              echo "[Unit]
              Description=Minecraft Server
              After=network.target

              [Service]
              Restart=always
              ExecStart=/usr/bin/docker run -d -p 25565:25565 -e EULA=TRUE itzg/minecraft-server
              ExecStop=/usr/bin/docker stop %n

              [Install]
              WantedBy=multi-user.target" | sudo tee /etc/systemd/system/minecraft.service
              # Enable the Minecraft service
              sudo systemctl enable minecraft.service
              # Start the Minecraft service
              sudo systemctl start minecraft.service
              EOF

  tags = {
    Name = "MinecraftServer"
  }
}



output "instance_public_ip" {
  value = aws_instance.minecraft_server.public_ip
}