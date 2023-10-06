module "aws_producao" {
  source        = "../Infra"
  ami           = "ami-03f65b8614a860c29 " # Ubuntu 22.04
  instance      = "t2.micro"
  regiao        = "us-west-2"
  key           = "Prod"
  securityGroup = "Prod"
  minimo        = 1
  maximo        = 10
  nomeGrupo     = "Prod"
  producao      = true
}

# ### SERVIDOR PROD
# resource "aws_instance" "servidorPROD" {
#   ami           = var.ami
#   instance_type = var.instance
#   key_name      = aws_key_pair.Prod.key_name
#   tags          = { Name = "Servidor de Producao" }
# }