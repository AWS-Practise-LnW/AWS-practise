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

resource "aws_ebs_volume" "jenkins_master_volume" {
  availability_zone = aws_instance.jenkins_master.availability_zone
  size              = 8   # 8 GB volume
  tags = {
    Name = "Jenkins Master Volume"
  }
}

resource "aws_ebs_volume" "jenkins_slave_volume" {
  availability_zone = aws_instance.jenkins_slave.availability_zone
  size              = 8   # 8 GB volume
  tags = {
    Name = "Jenkins Slave Volume"
  }
}

resource "aws_volume_attachment" "jenkins_master_attachment" {
  device_name = "/dev/sdh"
  instance_id = aws_instance.jenkins_master.id
  volume_id   = aws_ebs_volume.jenkins_master_volume.id
}

resource "aws_volume_attachment" "jenkins_slave_attachment" {
  device_name = "/dev/sdh"
  instance_id = aws_instance.jenkins_slave.id
  volume_id   = aws_ebs_volume.jenkins_slave_volume.id
}

output "jenkins_master_public_ip" {
  value = aws_instance.jenkins_master.public_ip
}

output "jenkins_slave_public_ip" {
  value = aws_instance.jenkins_slave.public_ip
}
