resource "aws_lb" "eks_alb" {
  name               = "eks-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = [aws_subnet.public-a.id, aws_subnet.public-b.id]
}

resource "aws_lb_target_group" "eks_tg" {
  name     = "eks-tg"
  port     = 30080
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc-dev.id

  health_check {
    path                = "/actuator/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "eks_listener" {
  load_balancer_arn = aws_lb.eks_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks_tg.arn
  }
}

resource "aws_autoscaling_attachment" "asg_tg" {
  autoscaling_group_name = data.aws_autoscaling_group.eks_asg.name
  lb_target_group_arn    = aws_lb_target_group.eks_tg.arn
}