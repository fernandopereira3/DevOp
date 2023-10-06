#!/bin/bash
cd /home/
curl  https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo python3 -m pip install ansible 
sudo su
tee -a playbook.yml > /home/ubuntu/playbook.yml <<EOT
- hosts: localhost
  tasks:
  - name: Install node
    community.general.snap:
      name: node
      classic: true

  - name: clone
    ansible.builtin.git:
      repo: https://github.com/fernandopereira3/node_server.git
      dest: /home/ubuntu/node_server
      separate_git_dir: /home/ubuntu/node_server.git
      version: main

  - name: Execute the command in remote shell; stdout goes to the specified file on the remote
    ansible.builtin.shell: 
      cmd: cd /home/ubuntu/node_server/

  - name: Executar node server 
    ansible.builtin.shell:
      cmd: node server.js > log.txt &
EOT
ansible-plabook playbook.yml