#terraform apply –var “aws_access_key_id=<your access key>” –var “aws_secret_access_key=<your secret access key>” -var "bucket_name=<a globally unique name>"

variable "AWS_A_KEY" {}
variable "AWS_S_KEY" {}

variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "AMIS" {
  type = "map"

  default = {
    ap-south-1 = "ami-f9daac96"
  }
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "jbawskey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "jbawskey.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ec2-user"
}

variable "KEYNAME" {}
variable "IAMPROFILE" {}
variable "VPC-ZONE-AZ1" {}
variable "VPC-ZONE-AZ2" {}
variable "BUCKETNAME" {}
