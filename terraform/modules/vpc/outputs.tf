output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_group" {
  value = aws_db_subnet_group.wordpress_db_subnet_group.name
}

output "subnets" {
  value = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}


