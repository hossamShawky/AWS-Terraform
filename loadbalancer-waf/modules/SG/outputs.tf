output "security_group" {
  value = aws_security_group.web_sg.id
}

output "lb_security_group" {
  value = aws_security_group.lb_security_group.id
}