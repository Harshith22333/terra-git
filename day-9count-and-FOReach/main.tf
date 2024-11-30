# without list varaible 
 resource "aws_instance" "myec2" {
     ami = "ami-0453ec754f44f9a4a"
     instance_type = "t2.micro"
     count =3
     tags = {
       Name = "hsk"
       Name = "hsk-${count.index}"
     }
 }