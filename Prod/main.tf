module "aws_producao" {
  source = "../Infra"
  ami = "ami-069a9077d702fe1d8" # Suse 15
  instance = "t2.micro"
  key = "Prod"
  securityGroup = "Prod"
  minimo = 1
  maximo = 10
  nomeGrupo = "Prod"
}

# ### SERVIDOR PROD
# resource "aws_instance" "servidorPROD" {
#   ami           = var.ami
#   instance_type = var.instance
#   key_name      = aws_key_pair.Prod.key_name
#   tags          = { Name = "Servidor de Producao" }
# }