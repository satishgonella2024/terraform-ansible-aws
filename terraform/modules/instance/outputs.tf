output "public_ip" {
  value = aws_instance.wordpress.public_ip
}

output "instance_id" {
  value = aws_instance.wordpress.id
}

