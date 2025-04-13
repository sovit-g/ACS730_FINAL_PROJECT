# Public Webserver IPs
output "public_webserver_ips" {
  description = "Public IP addresses of the webservers"
  value       = aws_instance.webservers[*].public_ip
}

# Private Instance IPs (DB Server 5 and VM6)
output "private_instance_ips" {
  description = "Private IP addresses of DB Server 5 and VM6"
  value = [
    aws_instance.db_server5.private_ip,
    aws_instance.VM6.private_ip
  ]
}


# ALB DNS Name
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.webserver.dns_name
}
