terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = var.regiao
}

#### servidor DEV
resource "aws_instance" "servidorDEV" {
  ami           = var.ami
  instance_type = var.instance
  key_name      = var.key
  tags          = { Name = "Servidor Dev" }
}

resource "aws_key_pair" "Dev" {
  key_name   = var.key
  public_key = file("/Users/fernando/devop/iac/.key/Dev.pub")
}

### SERVIDOR PROD

resource "aws_launch_template" "template_ex" {
  image_id = var.ami
  instance_type = var.instance
  key_name = var.key
  tags = { Name = "Terraform Python"} 
  security_group_names = [ var.securityGroup ]
  user_data = filebase64("installansible.sh")
}

resource "aws_autoscaling_group" "grupoescalar" {
  availability_zones = [ "${var.regiao}a" ]
  name = var.nomeGrupo
  max_size = var.maximo
  min_size = var.minimo
  launch_template {
    id = aws_launch_template.template_ex.id
    version = "$Latest"
  }
}

resource "aws_key_pair" "Prod" {
  key_name   = var.key
  public_key = file("/Users/fernando/devop/iac/.key/Prod.pub")
}
