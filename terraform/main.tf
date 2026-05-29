provider "aws" {
  region = "us-east-1"
}


data "aws_vpc" "default" {
    default=true
  
}
resource "aws_security_group" "my-sg" {
  name        = "zahra-sg-12345"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  #ssh
   ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  #jenkins
   ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  #sonarqube
   ingress {
    from_port        = 9000
    to_port          = 9000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  #promethus
   ingress {
    from_port        = 9090
    to_port          = 9090
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  #grafana
   ingress {
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "ec2" {
  ami           = "ami-091138d0f0d41ff90"
  instance_type = "t3.micro"
  key_name        = "key_zahra"  
  vpc_security_group_ids = [aws_security_group.my-sg.id]


   root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

   # Add swap space for extra disk space on launch automatically
  user_data = <<-EOF
    #!/bin/bash
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
  EOF

  tags = {
    Name = "devops-jenkins-master"
  }
}
