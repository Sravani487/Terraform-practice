#This code is not working as expected.Need to check this properly.
resource "aws_db_instance" "master_db" {
  provider = aws.primary
  allocated_storage       = 10
  identifier =             "master"
  db_name                 = "mydb"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                    = "admin"
  password                = "Cloud123"
  db_subnet_group_name    = aws_db_subnet_group.sub-grp-1.id
  parameter_group_name    = "default.mysql8.0"
  backup_retention_period  = 7   # Retain backups for 7 days
  backup_window            = "02:00-03:00" # Daily backup window (UTC)

  # Enable performance insights
#   performance_insights_enabled          = true
#   performance_insights_retention_period = 7  # Retain insights for 7 days
  maintenance_window = "sun:04:00-sun:05:00"  # Maintenance every Sunday (UTC)
  deletion_protection = true
  skip_final_snapshot = true
  #depends_on = [ aws_db_subnet_group.sub-grp.id ]
}

resource "aws_db_instance" "read_replica" {
  provider             = aws.replica
  identifier           = "read-replica"
  replicate_source_db  = aws_db_instance.master_db.arn
  instance_class       = "db.t3.micro"
  engine               = "mysql"
  engine_version       = "8.0" # Must match the master's engine version
  skip_final_snapshot  = true
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.sub-grp-2.id 
  backup_retention_period = 7  # Backups are typically handled by the master
  depends_on = [ aws_db_instance.master_db]


}


resource "aws_vpc" "name" {
    provider = aws.primary
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "dev"
    }
  
}
resource "aws_subnet" "subnet-1" {
    provider = aws.primary
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
  
}
resource "aws_subnet" "subnet-2" {
    provider = aws.primary
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"
  
}
resource "aws_db_subnet_group" "sub-grp-1" {
  provider = aws.primary
  name       = "mynewsubnett"
  subnet_ids = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]

  tags = {
    Name = "My DB subnet group"
  }
}


resource "aws_vpc" "name-2" {
    provider  = aws.replica
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "dev"
    }
  
}
resource "aws_subnet" "subnet-3" {
     provider  = aws.replica
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-west-2a"
  
}
resource "aws_subnet" "subnet-4" {
     provider  = aws.replica
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-west-2b"
  
}
resource "aws_db_subnet_group" "sub-grp-2" {
     provider  = aws.replica
  name       = "myothersubnett"
  subnet_ids = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]

  tags = {
    Name = "My DB subnet group-2"
  }
}
