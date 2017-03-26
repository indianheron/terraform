# Terraform for Wordpress Site on Azure
###  Pre-requisite
- You should have a Azure Credential file 
- A remote location especially a GitHub Tag for your wordpress site. The tag should contain a database file along with code folder
- **extract_name** is the name of folder obtain post extract 

# What you need to create to at your end ?
Create a **terraform.tfvars** at same location 

```sh 
subscription_id = "<sub-id>"
client_id       = "<app-id>"
client_secret   = "<secret>"
tenant_id       = "<tenant-id>"
key_file_pub    = "<path of public key file>"
key_file_pri    = "<path of private key file>"
```

Fill in the **roles/apache/vars/main.yml** file

```sh
---
# vars file for apache
serv_name: "<ser_name>"
serv_alias: "<ser_alias>"
tag_url: "<tag_url>"
gz_name: "<gz f name>"
extract_name: "<post extract name>"
```
# How to run ?
```
 terraform apply -var-file <name of file>.tfvars
```

# How to destroy ?
```
terraform destroy -var-file <name of file>.tfvars
```