output "key_name" {
  value = aws_key_pair.KeyPair.key_name
}
output "AMI" {
  value = data.aws_ami.ubuntu_img.id
}

output "ec2s_ids" {
  value = aws_instance.EC2[*].id
}