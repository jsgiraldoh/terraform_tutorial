provider "aws" {
	region = "us-west-2"
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "Packer Builder"

  ami                    = "ami-070c2b9448b7e5fe7"
  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = ["sg-0f3df87f16ee2cd9a"]
  subnet_id              = "subnet-0d8479eefe63e0056"
  key_name   = "tf_key"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  } 

}

module "ec2_instancedb" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "Mongo DB"

  ami                    = "ami-0011964644468a877"
  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = ["sg-0f3df87f16ee2cd9a"]
  subnet_id              = "subnet-0d8479eefe63e0056"
  key_name   = "tf_key"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}