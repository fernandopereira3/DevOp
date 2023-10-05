#!/bin/bash
cd /home/
curl  https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo python3 -m pip install ansible 
tee -a playbook.yml > /home/ <<EOT
- hosts: localhost
  tasks:
  - name: Instalando o NODE
    snap
      pkg:
      - node
      update_cache: yes
    become: yes
  - name: Baixando git
    ansible.builtin.git:
    repo: 'https://github.com/fernandopereira3/node_server.git'
    dest: /home/app
  - name: Executando o server
    shell: 'cd /home/app; sudo node server.js'
EOT
ansible-plabook playbook.yml