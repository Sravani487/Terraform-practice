resource "aws_instance" "name" {
    ami = "ami-0bdd88bd06d16ba03"
    instance_type = "t3.micro"
    tags = {
      Name = "aws server"
    }
  
}

#The below command import the configurations from Aws console to terraform and updates state file.Here Instance id we get 
#from Aws console 

#terraform import aws_instance.name instance id