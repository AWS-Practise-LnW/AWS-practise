provider "aws" {
  region = "us-east-1" # Change this to your preferred region
}

resource "tls_private_key" "my_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "my-terraform-key"
  public_key = tls_private_key.my_ssh_key.public_key_openssh
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-0c55b159cbfafe1f0" # Change this based on your region (Amazon Linux 2)
  instance_type = "t2.micro"

  key_name = aws_key_pair.generated_key.key_name

  tags = {
    Name = "Terraform-EC2"
  }
}

output "private_key_pem" {
  value     = tls_private_key.my_ssh_key.private_key_pem
  sensitive = true
}

output "public_ip" {
  value = aws_instance.my_ec2.public_ip
}
