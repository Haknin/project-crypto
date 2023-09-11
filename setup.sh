#!/usr/bin/bash -xe
sudo yum install python -y
sudo yum install python-pip -y
sudo pip install ansible
ansible-playbook crypto-site/requirements.yml
ansible-playbook crypto-site/deploy.yml
