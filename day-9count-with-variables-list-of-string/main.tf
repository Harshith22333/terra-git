# example-2 with variables list of string 



# main.tf
resource "aws_instance" "sandbox" {
  ami           = var.ami
  instance_type = var.instance_type
  count        = length(var.sandboxes)

  tags = {
    Name = var.sandboxes[count.index]
  }
}
