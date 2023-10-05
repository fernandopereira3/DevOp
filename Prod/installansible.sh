#!/bin/bash
cd /home/
curl  https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo python3 -m pip install ansible 
tee -a playbook.yml > /dev/null <<EOT
- hosts: localhost
  tasks:
  - name: Instalando o python3, virtualenv
    apt:
      pkg:
      - python3
      - virtualenv
      update_cache: yes
    become: yes
  - name: Instalando dependencias com pip (Django e Django Rest)
    pip:
      virtualenv: /home/tcc/venv
      name:
        - django
        - djangorestframework
  - name: Verificando se o projeto ja existe
    stat:
      path: /home/tcc/setup/settings.py
    register: projeto
  - name: Iniciando o projeto
    shell: '. /home/tcc/venv/bin/activate; django-admin startproject setup /home/tcc/'
    when: not projeto.stat.exists
  - name: Alterando o hosts do settings
    lineinfile:
      path: /home/tcc/setup/settings.py
      regexp: 'ALLOWED_HOSTS'
      line: 'ALLOWED_HOSTS = ["*"]'
      backrefs: yes
EOT
ansible-plabook playbook.yml