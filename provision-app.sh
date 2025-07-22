#!/bin/bash -e
docker run -d --name=grafana -p 3000:3000 grafana/grafana
sudo /usr/local/bin/docker-compose up -d
