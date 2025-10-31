
resource "aws_instance" "name" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.name.id
  availability_zone = var.availability_zone
  tags = {
    Name = "dev"
  }
  
}

resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    
}

resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
  
}