#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
aws s3 ls > test.out
BNAME=$(cat test.out | head -1 | cut -d " " -f3)
for i in ami-id instance-id public-ipv4
do
        D=$(curl -s http://169.254.169.254/latest/meta-data/$i)
        echo "$i => $D" >> test.txt
done
aws s3 cp test.txt s3://$BNAME/ --region 'ap-south-1'
aws s3 cp s3://$BNAME/test.txt /var/www/html/ --region 'ap-south-1'
sudo service httpd restart;
