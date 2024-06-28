# Allow HTTP/S,SSH Traffic

resource "aws_security_group" "web_sg" {
  vpc_id      = var.vpc_id
  description = "Allow HTTP/S,SSH Traffic Only  From LB"
  name        = "${var.project}-WebSG"
  tags = {
    "Name" = "${var.project}-WebSG"
  }
  ingress {
    to_port         = "80"
    from_port       = "80"
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_security_group.id]
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
  depends_on = [aws_security_group.lb_security_group]

}


resource "aws_security_group" "lb_security_group" {

  vpc_id      = var.vpc_id
  description = "Allow HTTP/S  Traffic"
  name        = "${var.project}-LBSG"
  tags = {
    "Name" = "${var.project}-LBSG"
  }
  ingress {
    to_port     = "80"
    from_port   = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    to_port     = "443"
    from_port   = "443"
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