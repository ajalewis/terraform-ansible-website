# terraform-ansible-simplewebsite

## How to Setup

### Terraform [main.tf]

1. shared_credentials_files = ["/your/aws/creds/here"] Optional to include relevant profile
2. Adjust Region/AVZ if necessary 

### Ansible [inventory]

1. Specify <public_ip_address> 
2. Specify ansible_ssh_private_key_file="<path/to/privatekey>"

## How to Run

### Terraform

1. `$ terraform init`
2. `$ terraform plan`
3. `$ terraform apply`

### Ansible

1. `$ ansible-playbook -i invenotry website.yaml`

### To test

`$ curl <ip_address>`
