output "public_loadbalancer_dns" {
  value = aws_lb.lb_waf.dns_name
}