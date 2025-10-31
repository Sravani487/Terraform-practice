ami_id  = "ami-0bdd88bd06d16ba03" #add required ami id
instance_type = "t3.micro"       #add required instance type
availability_zone = "us-east-1a" #add requied az

#terraform plan -var-file="dev.tfvars" if var file name is different like dev.tfvars
#terraform apply -var-file="dev.tfvars" if var file name is different like dev.tfvars