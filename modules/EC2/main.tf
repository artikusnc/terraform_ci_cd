resource "aws_instance" "example" {
  ami           = "ami-0eb11ab33f229b26c" # ID da AMI do Debian
  instance_type = "t2.micro"
  subnet_id     = "subnet-049c479b38cd6e6f0"
  key_name      = "ec2_key"
  security_groups = ["sg-0d59084babbe4c2b2", "sg-0b0c398f0b0cdca9c"]
}