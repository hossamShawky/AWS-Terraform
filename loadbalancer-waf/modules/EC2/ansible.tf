resource "null_resource" "ansible-playbook" {

  provisioner "local-exec" {
    command = "/usr/bin/sh ${path.module}/ansible.sh"
  }
  depends_on = [aws_instance.EC2]
}