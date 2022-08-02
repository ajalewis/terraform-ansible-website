## Create VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "website-vpc"
  cidr = "10.0.0.0/16"
  azs            = ["ap-southeast-2a"]
  public_subnets = ["10.0.101.0/24"]

}

#Create SSH keys
resource "tls_private_key" "web_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.generated_key_name
  public_key = tls_private_key.web_key.public_key_openssh

  provisioner "local-exec" {    # Generate "web_key.pem" in current directory
    command = <<-EOT
      echo '${tls_private_key.web_key.private_key_pem}' > ./'${var.generated_key_name}'.pem
      chmod 400 ./'${var.generated_key_name}'.pem
    EOT
  }

}

## Create EC2 instance
resource "aws_instance" "web_vm" {
  # Based on Ubuntu Server 20.04 LTS
  ami                         = data.aws_ami.ubuntu-ec2.id
  key_name                    = "web_key"
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.website_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "web_vm"
  }
}

resource "aws_eip" "elastic_ip" {
  instance = aws_instance.web_vm.id
  vpc      = true
}

## Define SG for SSH & website access
resource "aws_security_group" "website_sg" {
  name        = "vm-security-group"
  description = "Allow SSH & Apache"

  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${local.my_ip.ip}/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
