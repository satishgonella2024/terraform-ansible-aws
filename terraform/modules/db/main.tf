resource "aws_db_instance" "wordpress_db" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  publicly_accessible    = false
  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = var.db_subnet_group
  skip_final_snapshot = true


  tags = {
    Name = "WordPress-DB"
  }
}
