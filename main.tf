provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "sigma" {
  ami           = "ami-97785bed"
  instance_type = "t2.micro"
tags {    Name = "terraform.sigma"  }
}

resource "aws_security_group" "instance" {  
name = "terraform-example-instance"  
ingress {    
		from_port   = 8080    
		to_port     = 8080    
		protocol    = "tcp"    
		cidr_blocks = ["0.0.0.0/0"]  
		}
}
