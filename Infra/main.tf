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
  region  = "us-west-2"
}

resource "aws_launch_template" "template_ex" {
  image_id = "ami-03f65b8614a860c29"
  instance_type = var.instance
  key_name = var.key
  tags = { Name = "Terraform NODEJS"} 
  security_group_names = [ var.securityGroup ]
  user_data = var.producao ? filebase64("installansible.sh") : ""
}

resource "aws_autoscaling_group" "grupoescalar" {
  availability_zones = [ "${var.regiao}a" ]
  name = var.nomeGrupo
  max_size = var.maximo
  min_size = var.minimo
  target_group_arns = var.producao ? [ aws_lb_target_group.alvoLoad[0].arn ] : []
  launch_template {
    id = aws_launch_template.template_ex.id
    version = "$Latest"
  }
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
  count = var.producao ? 1 : 0 
  
}

resource "aws_lb_target_group" "alvoLoad" {
  name = "maquinaAlvo"
  port = "8000"
  protocol = "HTTP"
  vpc_id = aws_default_vpc.default.id
  count = var.producao ? 1 : 0 
}

resource "aws_default_vpc" "default" {
  
}

resource "aws_lb_listener" "entradaLB" {
  load_balancer_arn = aws_lb.loadbalance[0].arn
  port = 8000
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alvoLoad[0].arn
  }
  count = var.producao ? 1 : 0 
}

#####################

resource "aws_autoscaling_policy" "autoProducao" {
  name = "escala-terraform"
  autoscaling_group_name = var.nomeGrupo
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
  count = var.producao ? 1 : 0 
}

#####################
resource "aws_key_pair" "Prod" {
  key_name   = var.key
  public_key = file("/Users/fernando/devop/iac/.key/Prod.pub")
}

##### atualizacao de repositorio ####