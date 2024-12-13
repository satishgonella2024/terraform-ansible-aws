provider "aws" {
  region = "eu-west-2"
}

resource "aws_key_pair" "key" {
  key_name   = "wordpress-sample-key"
  public_key = file("wordpress-sample-key.pub")
}

module "vpc" {
  source = "../../modules/vpc"
  region = "eu-west-2"
}

module "instance" {
  source            = "../../modules/instance"
  ami_id            = "ami-009d83c002e2789f1"
  instance_type     = "t2.micro"
  subnet_id         = module.vpc.subnets[0]
  security_group_id = aws_security_group.ec2_sg.id
}

module "db" {
  source             = "../../modules/db"
  db_username        = "admin"
  db_password        = "securepassword123"
  security_group_id  = aws_security_group.rds_sg.id
  db_subnet_group    = module.vpc.subnet_group
}

resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.vpc_id
}

resource "aws_route_table" "public" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = module.vpc.subnets[0]
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ec2_sg" {
  name_prefix = "wordpress-ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "wordpress-rds-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "ec2_instance_id" {
  value = module.instance.instance_id
}

output "ec2_public_ip" {
  value = module.instance.public_ip
}

output "rds_endpoint" {
  value = module.db.db_endpoint
}

variable "region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "eu-west-2"
}
