terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
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
              ExecStop=/usr/bin/docker exec mc rcon-cli stop
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

output "vpc_security_group_ids" {
  value = aws_instance.minecraft_server.vpc_security_group_ids
}