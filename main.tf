provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "sigma" {
  ami           = "ami-97785bed"
  instance_type = "t2.micro"
tags {    Name = "terraform.sigma"  }
}
