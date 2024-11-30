resource "aws_instance" "name" {
  ami = var.myyyami
  instance_type = var.myinstance
  key_name = var.itsmykey
  tags = {
    Name = "myserver"
  }
}

resource "aws_s3_bucket" "mybucket" {
  bucket = var.mys3bucket
}