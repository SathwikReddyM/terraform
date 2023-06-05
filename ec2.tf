provider "aws" {
  region = "us-east-2"
  access_key = "AKIAVONCJ7TZNSMQYAHZ"
  secret_key = "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"
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
