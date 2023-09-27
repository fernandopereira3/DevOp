module "aws_producao" {
  source = "../Infra"
  ami = "ami-0c65adc9a5c1b5d7c" # ububtu 20.04
  instance = "t2.micro"
  key = "Prod"
}

# ### SERVIDOR PROD
# resource "aws_instance" "servidorPROD" {
#   ami           = var.ami
#   instance_type = var.instance
#   key_name      = aws_key_pair.Prod.key_name
#   tags          = { Name = "Servidor de Producao" }
# }