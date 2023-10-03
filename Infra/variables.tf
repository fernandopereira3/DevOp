variable "regiao" {
  type    = string
  default = "us-west-2"
}
variable "instance" {
  type = string
  # default = "t2.micro"
}
variable "ami" {
  type = string
  # default = "ami-0c65adc9a5c1b5d7c" # Ubuntu 20.04 Oregon
}

variable "key" {
  type = string
}

variable "securityGroup" {
  type = string
}

variable "minimo" {
  type = number
}

variable "maximo" {
  type = number
}

variable "nomeGrupo" {
  type = string
}