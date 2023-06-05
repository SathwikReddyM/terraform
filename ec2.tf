provider "aws" {
  region = "us-east-2"
  access_key = "{YOUR_ACCESS_KEY}"
  secret_key = "{YOUR_SECRET_KEY}"
}

variable "ingressrules" {
  type = list(number)
  default = [0]
}
variable "egressrules" {
  type = list(number)
  default = [0]
}

resource "aws_instance" "ec2" {
  ami = "ami-024e6efaf93d85776"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.ec2.name]
user_data = "${file("/terraform/shell.sh")}"
tags = {
  Name = "Sat"
}
}

resource "aws_security_group" "ec2" {
  name = "Allow Traffic"

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port = port.value
      to_port = port.value
      protocol = "-1"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
  }

  dynamic "egress" {
    iterator = port
    for_each = var.egressrules
    content {
      from_port = port.value
      to_port = port.value
      protocol = "-1"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
  }
}
