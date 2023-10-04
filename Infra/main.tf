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
# resource "aws_instance" "servidorDEV" {
#   ami           = var.ami
#   instance_type = var.instance
#   key_name      = var.key
#   tags          = { Name = "Servidor Dev" }
# }

# resource "aws_key_pair" "Dev" {
#   key_name   = var.key
#   public_key = file("/Users/fernando/devop/iac/.key/Dev.pub")
# }

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
  target_group_arns = [ aws_lb_target_group.alvoLoad.arn ]
}

################

resource "aws_default_subnet" "subnet_1" {
  availability_zone = "${var.regiao}a"
}

resource "aws_default_subnet" "subnet_2" {
  availability_zone = "${var.regiao}b"
}

resource "aws_lb" "loadbalance" {
  internal = false
  subnets = [ aws_default_subnet.subnet_1.id, aws_default_subnet.subnet_2.id ]
  
}

resource "aws_lb_target_group" "alvoLoad" {
  name = "maquinaAlvo"
  port = "8000"
  protocol = "HTTP"
  vpc_id = aws_default_vpc.default.id
}

resource "aws_default_vpc" "default" {
  
}

resource "aws_lb_listener" "entradaLB" {
  load_balancer_arn = aws_lb.loadbalance.arn
  port = 8000
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alvoLoad.arn
  }
}

#####################

resource "aws_key_pair" "Prod" {
  key_name   = var.key
  public_key = file("/Users/fernando/devop/iac/.key/Prod.pub")
}
