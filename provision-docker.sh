#!/bin/bash -e

if hash docker 2>/dev/null; then
  echo "Docker aleady installed"
else
  sudo yum update -y
  sudo amazon-linux-extras install -y docker
  sudo service docker start
  sudo usermod -a -G docker ec2-user
  sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod 711 /usr/local/bin/docker-compose
fi
