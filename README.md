# AWS/Docker deployment via Terraform
This app was created to complete [DevOps interview task](https://github.com/lukyanetsv/devops-interview-task).

Task was split on next levels:
- Golang installation and app testing on standalone AWS EC2 instance
- Creation of dockerfile which will use golang image and map server.go file from local file system to docker container
- Creation of Docker image from dockerfile and upload to DockerHub
- Creation of Running Docker container from Docker image with 8080 port mapping
- Creation of Terraform script which will run created Docker container in EC2 instance
- Add AWS ELB to Terraform script
- Add AWS Autoscaling group to Terraform script

## Creation of Docker image
Docker image was created from dockerfile
```sh
FROM golang
MAINTAINER Vitaliy Buryak <vibu@ukr.net>
ADD . /usr/apps/
ADD server.go server.go
EXPOSE 8080
RUN go run /usr/apps/server.go &
```

App was started by next commands:
```sh
docker build -f dockerfile .
docker run -d -i -p 8080:8080 -t 3d4ded1b9d48 go run server.go
```
Upload of Docker image:
```sh
docker tag 3d4ded1b9d48 vibu/3d4ded1b9d48
docker push vibu/3d4ded1b9d48
```

Docker image available for download in [DockerHub](https://hub.docker.com/r/vibu/3d4ded1b9d48/)
## Terraform script usage
Script was created in Terraform v0.11.3

Add your AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY to your .profile:
```sh
export AWS_ACCESS_KEY_ID=xxxxxx
export AWS_SECRET_ACCESS_KEY=xxxxxx
```
Install Terraform acorring to [Manual](https://www.terraform.io/intro/getting-started/install.html).
Download Terraform scipts from this repo:
```sh
https://github.com/HaimMyasnikoff/terraform
```
Run main script:
```sh
terrarom init
terraform apply
```
Enteryou DockerHub account login and password after the prompts:
```sh
var.docker_login
  Enter your DockerHub login
  Enter a value: <your DockerHub login, not e-mail>
var.docker_password
  Enter your DockerHub password
  Enter a value: <your DockerHub password>
```


## Task evaluation
For task evaluation can be used any HTTP load generator which will send 10-15k http requests on port 8080 of the ELB.
In same time, you can:
- try to open in your browser http://<ELB DNS name>:8080
- open [AWS Console](https://console.aws.amazon.com) and chech number of created EC2 instances with names *Go-App-ASG*



