#!/usr/bin/env bash
sudo yum -y install docker
sudo service docker start
sudo docker pull vibu/3d4ded1b9d48
sudo docker run -d -i -p 8080:8080 -t 3d4ded1b9d48 go run server.go
