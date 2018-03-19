#Set AWS region
provider "aws" {
  region     = "us-east-1"
}

#Go app
resource "aws_launch_configuration" "sigma" {
        image_id				=	"ami-97785bed"
        instance_type	=	"t2.micro"
		security_groups = ["${aws_security_group.go.id}"]
        key_name		=	"myFirstEC2"
        user_data 		=	"${file("app/go_app.sh")}"

								}
								
data "aws_availability_zones" "all" {}

# Autoscaling group
resource "aws_autoscaling_group" "asg" {
  launch_configuration = "${aws_launch_configuration.sigma.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]

  load_balancers    = ["${aws_elb.go.name}"]
  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "Go-App-ASG"
    propagate_at_launch = true
  }
}
						
# Load balancer
resource "aws_elb" "go" {
  name = "GoELB"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 8080
    lb_protocol = "http"
  }
  
}
  
  
#Security group creation
resource "aws_security_group" "go" {  
		name 			= "terraform-example-instance"  
		ingress {	from_port   = 8080    
					to_port     = 8080
					protocol    = "tcp"
					cidr_blocks = ["0.0.0.0/0"]  
				}
		ingress {	from_port   = 22    
					to_port     = 22
					protocol    = "tcp"
					cidr_blocks = ["0.0.0.0/0"]  
				}
		ingress {	from_port   = 80    
					to_port     = 80
					protocol    = "tcp"
					cidr_blocks = ["0.0.0.0/0"]  
				}
		ingress {	from_port   = 443    
					to_port     = 443
					protocol    = "tcp"
					cidr_blocks = ["0.0.0.0/0"]  
				}
		egress {	from_port   = 443    
					to_port     = 443
					protocol    = "tcp"
					cidr_blocks = ["0.0.0.0/0"]  
				}
		egress {	from_port   = 8080    
					to_port     = 8080
					protocol    = "tcp"
					cidr_blocks = ["0.0.0.0/0"]  
				}
		egress {	from_port   = 22    
					to_port     = 22
					protocol    = "tcp"
					cidr_blocks = ["0.0.0.0/0"]  
				}
		egress {	from_port   = 80    
					to_port     = 80
					protocol    = "tcp"
					cidr_blocks = ["0.0.0.0/0"]  
				}
				}

				

