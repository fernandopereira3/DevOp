module "aws_desenvolvedor" {
    source = "../Infra"
    ami = "ami-069a9077d702fe1d8" #suse 15
    instance = "t1.micro"
    key = "Dev"
}

# #### servidor DEV
# resource "aws_instance" "servidorDEV" {
#   ami           = var.ami
#   instance_type = var.instance
#   key_name      = aws_key_pair.Dev.key_name
#   tags          = { Name = "Servidor Dev" }
# }