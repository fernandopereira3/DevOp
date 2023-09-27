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

resource "aws_instance" "servidorPROD" {
  ami           = var.ami
  instance_type = var.instance
  key_name      = var.key
  tags          = { Name = "Servidor de Producao" }

}

resource "aws_key_pair" "Prod" {
  key_name   = var.key
  public_key = file("/Users/fernando/devop/iac/.key/Prod.pub")
}

##### OUTPUTS

output "IP_PRODUCAO" {
  value = aws_instance.servidorPROD.public_ip
}

output "IP_DEV" {
  value = aws_instance.servidorDEV.public_ip
}
