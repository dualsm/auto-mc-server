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
  ami = "ami-04b70fa74e45c3917" # Canonical, Ubuntu, 24.04 LTS, amd64 noble image build on 2024-04-23 (for us-east-1)
  # change the "ami" field to your region's ami for ubuntu 24. If using us-east-1, leave as is (6-8-2024)
  instance_type               = "t2.medium"
  key_name                    = "my-minecraft-key"
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/my-minecraft-key.pem")
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    script = "minecraft-setup.sh"
  }

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