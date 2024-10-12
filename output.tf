# Output Public IP

output "my_nginx_server_public_ip" {

  value = aws_instance.my_nginx_server.public_ip

}

# Output Public DNS

output "aws_instance_public_dns" {

  value = aws_instance.my_nginx_server.public_dns

}


