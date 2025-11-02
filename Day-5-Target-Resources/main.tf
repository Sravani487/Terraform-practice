resource "aws_instance" "name" {
    ami ="ami-0bdd88bd06d16ba03"
    instance_type = "t3.micro"
    tags = {
      Name ="Test ec2"
    }
  
}

resource "aws_s3_bucket" "name" {
  bucket = "s34gyu"
  
  
}

#target command we can apply for pirticular resource level. Below command is the refference
#terraform plan -target=aws_s3_bucket.name
#terraform apply -target=aws_s3_bucket.name
#terraform destroy -target=aws_s3_bucket.name