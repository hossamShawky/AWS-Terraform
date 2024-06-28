# Allow HTTP/S,SSH Traffic

resource "aws_security_group" "web_sg" {
  vpc_id      = var.vpc_id
  description = "Allow HTTP/S,SSH Traffic"
  name        = "${var.project}-WebSG"
  tags = {
    "Name" = "${var.project}-WebSG"
  }
  ingress {
    to_port     = "80"
    from_port   = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    to_port     = "22"
    from_port   = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}