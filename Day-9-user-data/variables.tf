variable "ami_id" {
    description = "passing ami values"
    default = "ami-0bdd88bd06d16ba03"
    type = string
  
}
variable "type" {
    description = "passing values to instance type"
    default = "t3.micro"
    type = string
  
}