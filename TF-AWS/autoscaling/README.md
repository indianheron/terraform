# Autoscaling using Terraform
###  Assumptions 
- You have a key available and uploaded on to AWS EC2 Blade 
- This script is using the default VPC and Subnets of AWS 
- Also an IAM Role is pre-created, which enable a EC2 Instance and S3 communication directly, without any need of providing SK and AK

# What you need to create to at your end ?
Create a **terraform.tfvars** at same location 

```sh 
$ cat terraform.tfvars
AWS_REGION = "<Region>"
KEYNAME = "<Key Name>"
IAMPROFILE = "<Role Name>"
VPC-ZONE-AZ1 = "<subnet-1az>"
VPC-ZONE-AZ2 = "<subnet-2az>"
```
# How to run ?
```
 terraform apply -var "AWS_A_KEY=*******" -var "AWS_S_KEY=*********" -var "BUCKETNAME=*****"
```

# How to destroy ?
```
terraform destroy -var "AWS_A_KEY=*******" -var "AWS_S_KEY=*********" -var "BUCKETNAME=*****"
```