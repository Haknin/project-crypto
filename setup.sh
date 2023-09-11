#!/usr/bin/bash -xe
sudo yum install python -y
sudo yum install python-pip -y
sudo pip install ansible
ansible-playbook project-crypto/requirements.yml
ansible-playbook project-crypto/deploy.yml
