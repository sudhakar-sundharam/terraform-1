# Terraform Nginx Demo - 2 AZs in Sydney

Mumbai ap-south-1 SCP blocked EC2 creation. Sydney ap-southeast-2 worked with Terraform.

## Resources
- 1 Security Group: port 22 and 80 open
- 2 EC2 t3.micro: ap-southeast-2a and ap-southeast-2b
- Ubuntu 22.04 + Nginx

## Verification
- curl http://3.27.192.18 -> Hello from 2a
- curl http://15.135.217.80 -> Hello from 2b

## Cleanup
terraform destroy -auto-approve
