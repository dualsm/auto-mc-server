#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo docker pull itzg/minecraft-server
cat << EOF | sudo tee /etc/systemd/system/minecraft.service
[Unit]
Description=Minecraft Server
After=network.target

[Service]
Restart=always
ExecStart=/usr/bin/docker run -d -p 25565:25565 -e EULA=TRUE itzg/minecraft-server
ExecStop=/usr/bin/docker exec mc rcon-cli stop
ExecStop=/usr/bin/docker stop %n

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable minecraft.service
sudo systemctl start minecraft.service