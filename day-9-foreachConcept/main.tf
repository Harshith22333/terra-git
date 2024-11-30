
  
variable "ami" {
  type    = string
  default = "ami-0453ec754f44f9a4a"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "sandboxes" {
  type    = list(string)
  default = ["testt", "prodt"]
}
variable "subnet_id" {
    type = string
    default = "subnet-0c617a623befe1ab6"
  
}
resource "aws_instance" "sandbox" {
  ami           = var.ami
  instance_type = var.instance_type
  for_each      = toset(var.sandboxes)
  subnet_id = var.subnet_id
#   count = length(var.sandboxes)
  tags = {
    Name = each.value # for a set, each.value and each.key is the same
  }
}