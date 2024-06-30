resource "aws_instance" "jenkins_instance" {
  subnet_id       = aws_subnet.jenkins_subnet.id
  key_name        = var.key_name
  security_groups = [aws_security_group.jenkins_security_group.id]
  ami             = var.ami
  instance_type   = var.type
  root_block_device {
    volume_size           = 9
    delete_on_termination = true
    volume_type           = "gp3" # default is gp2
    encrypted             = true
  }
  provisioner "local-exec" {
    command = " rm ./ansible/inventory && echo '[jenkins]' > ./ansible/inventory && echo '${aws_instance.jenkins_instance.public_ip} state=latest' >> ./ansible/inventory"
  }

  tags = {
    "Name" = "${var.project}-ec2"
  }
}