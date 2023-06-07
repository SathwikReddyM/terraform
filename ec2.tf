provider "aws" {
  region = "us-east-2"
  access_key = "YOUR_ACCESS_KEY"
  secret_key = "YOUR_SECRET_KEY"
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
  user_data = data.template_file.user_data.rendered
tags = {
  Name = "Testing"
}
}
data "template_file" "user_data" {
  template = "${file("/terraform/shell.sh")}"

  vars = {
    rds_endpoint = aws_db_instance.myrds.endpoint
    rds_username = aws_db_instance.myrds.username
    rds_password = aws_db_instance.myrds.password
  }
}
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "RDS Security Group"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_db_instance" "myrds" {
  allocated_storage   = 10
  storage_type        = "gp2"
  identifier          = "rdstf"
  engine              = "mysql"
  engine_version      = "8.0.32"
  instance_class      = "db.t3.micro"
  username            = "admin"
  password            = "Test!098"
  publicly_accessible = true
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "MyRDS"
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

