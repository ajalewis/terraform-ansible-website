variable "generated_key_name" {
  type        = string
  default     = "web_key"
}

data "http" "my_public_ip" {
    url = "https://ifconfig.co/json"
    request_headers = {
        Accept = "application/json"
    }
}

data "aws_ami" "amz-ec2" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04*"]
  }
}

locals {
    my_ip = jsondecode(data.http.my_public_ip.body)
}
