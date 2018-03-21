#Set AWS region
provider "aws" {
  region     = "us-east-1"
}

#Go app
resource "aws_launch_configuration" "sigma" {
        image_id                                =       "ami-97785bed"
        instance_type   =       "t2.micro"
                security_groups = ["${aws_security_group.go.id}"]
        key_name                =       "myFirstEC2"
        user_data               =       "${file("app/go_app.sh")}"

                                                                }

data "aws_availability_zones" "all" {}

# Autoscaling group
resource "aws_autoscaling_group" "asg" {
  name = "Autoscaling_Group"
 launch_configuration = "${aws_launch_configuration.sigma.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]

  load_balancers    = ["${aws_elb.go.name}"]
  health_check_type = "ELB"

  min_size = 2
  max_size = 10
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
                name                    = "terraform-example-instance"
                ingress {       from_port   = 8080
                                        to_port     = 8080
                                        protocol    = "tcp"
                                        cidr_blocks = ["0.0.0.0/0"]
                                }
                ingress {       from_port   = 22
                                        to_port     = 22
                                        protocol    = "tcp"
                                        cidr_blocks = ["0.0.0.0/0"]
                                }
                ingress {       from_port   = 80
                                        to_port     = 80
                                        protocol    = "tcp"
                                        cidr_blocks = ["0.0.0.0/0"]
                                }
                ingress {       from_port   = 443
                                        to_port     = 443
                                        protocol    = "tcp"
                                        cidr_blocks = ["0.0.0.0/0"]
                                }
                egress {        from_port   = 443
                                        to_port     = 443
                                        protocol    = "tcp"
                                        cidr_blocks = ["0.0.0.0/0"]
                                }
                egress {        from_port   = 8080
                                        to_port     = 8080
                                        protocol    = "tcp"
                                        cidr_blocks = ["0.0.0.0/0"]
                                }
                egress {        from_port   = 22
                                        to_port     = 22
                                        protocol    = "tcp"
                                        cidr_blocks = ["0.0.0.0/0"]
                                }
                egress {        from_port   = 80
                                        to_port     = 80
                                        protocol    = "tcp"
                                        cidr_blocks = ["0.0.0.0/0"]
                                }
                                }


resource "aws_autoscaling_policy" "asg"
        {
        name = "cpu"
        autoscaling_group_name = "Autoscaling_Group"
        adjustment_type = "ChangeInCapacity"
        scaling_adjustment = "1"
        cooldown = "300"
        policy_type = "SimpleScaling"
        }

resource "aws_cloudwatch_metric_alarm" "asg"
        {
        alarm_name = "cpu_more_80"
        comparison_operator = "GreaterThanOrEqualToThreshold"
        evaluation_periods = "2"
        metric_name = "CPUUtilization"
        namespace = "AWS/EC2"
        period = "60"
        statistic = "Average"
        threshold = "80"
 dimensions {
        AutoScalingGroupName = "${aws_autoscaling_group.asg.name}"
  }
        }
