#LB
resource "aws_lb" "lb_waf" {
  name               = "${var.project}-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.lb_security_gps]
  subnets            = var.lb_subnets
  tags = {
    "Name" = "${var.project}-LB"
  }

}
#Target Group
resource "aws_lb_target_group" "target_group" {
  name     = "${var.project}-TG"
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id
  tags = {
    "Name" = "${var.project}-LB"
  }
}

#Attach Ec2s To Target Group
resource "aws_lb_target_group_attachment" "target_gp_attach" {
  count            = length(var.ec2s_ids)
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.ec2s_ids[count.index]
  port             = var.port
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb_waf.arn
  port              = var.port
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}