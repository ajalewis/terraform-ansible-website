# terraform-ansible-simplewebsite

## How to Setup

### Terraform

1. Ensure AWS credentials are vaild (https://registry.terraform.io/providers/hashicorp/aws/latest/docs#shared-configuration-and-credentials-files)

### Ansible

1. Ensure Ansible is present on local machine (https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## How to Run

1. `$ terraform init`
2. `$ terraform plan` (optional)
3. `$ terraform apply`

### To test

`$ curl <public_ip_address>`
