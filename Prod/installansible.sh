#!/bin/bash
cd /home/
curl  https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo python3 -m pip install ansible 
tee -a playbook.yml > /dev/null <<EOT
- hosts: localhost
  tasks:
    - name: Install NodeJS
        yum:
        update_cache: yes
            pkg:
            - nodejs
        become: yes
        become_method: sudo
EOT
ansible-plabook playbook.yml