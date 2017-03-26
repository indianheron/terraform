#!/bin/bash 
echo " " >> ~/.ssh/config
echo "Host devyatra " >> ~/.ssh/config
echo "  HostName $1" >> ~/.ssh/config
echo "  User ubuntu" >> ~/.ssh/config 
echo "  IdentityFile $2" >> ~/.ssh/config

export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i hostfile playbook.yml --sudo --extra-vars "vm=devyatra"
