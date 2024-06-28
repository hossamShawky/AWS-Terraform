
# AWS_AMI
data "aws_ami" "ubuntu_img" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}
#KeyPair
##Generate Key Locally
resource "null_resource" "ssh-keygen" {
  provisioner "local-exec" {
    command = "yes | ssh-keygen -t rsa -b 2048 -f ${path.module}/ansible/lb_waf -N '' "
  }
}
resource "aws_key_pair" "KeyPair" {
  key_name   = "lb_waf"
  public_key = file("${path.module}/ansible/lb_waf.pub")
  depends_on = [null_resource.ssh-keygen]
}

#EC2s

resource "aws_instance" "EC2" {
  count                  = length(var.subnets)
  ami                    = data.aws_ami.ubuntu_img.id
  vpc_security_group_ids = [var.security_group]
  subnet_id              = var.subnets[count.index]
  key_name               = aws_key_pair.KeyPair.key_name
  instance_type          = "t2.micro"
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> ${path.module}/ansible/inventory"
  }
  tags = {
    Name = "Ec2-${var.project}-${count.index}"
  }
  root_block_device {
    volume_size           = 9
    delete_on_termination = true
    volume_type           = "gp3" # default is gp2
    encrypted             = true
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [data.aws_ami.ubuntu_img, aws_key_pair.KeyPair]
}


