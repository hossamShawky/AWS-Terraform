output "key_name" {
  value = module.EC2.key_name
}
output "AMI" {
  value = module.EC2.AMI
}

output "LB" {
  value = module.LB.public_loadbalancer_dns
}