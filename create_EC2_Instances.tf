provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "jenkins_master" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with your desired AMI
  instance_type = "t2.micro"
  key_name      = "your-ssh-key"           # Replace with your SSH key name

  tags = {
    Name = "Jenkins-Master"
  }
}

resource "aws_instance" "jenkins_slave" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with your desired AMI
  instance_type = "t2.micro"
  key_name      = "your-ssh-key"           # Replace with your SSH key name

  tags = {
    Name = "Jenkins-Slave"
  }
}

resource "aws_efs_file_system" "jenkins_efs" {
  creation_token = "jenkins-efs"
}

resource "aws_security_group" "jenkins_sg" {
  name_prefix = "jenkins-sg-"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "efs_mount" {
  security_group_id = aws_security_group.jenkins_sg.id
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

output "jenkins_master_public_ip" {
  value = aws_instance.jenkins_master.public_ip
}

output "jenkins_slave_public_ip" {
  value = aws_instance.jenkins_slave.public_ip
}
