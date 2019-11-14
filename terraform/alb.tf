resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb_security_group.id}"]
  subnets            = "${data.aws_subnet_ids.subnets.ids}"
}

data "aws_vpc" "default" {

}

data "aws_subnet_ids" "subnets" {
  vpc_id = "${data.aws_vpc.default.id}"
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.fargate_app.arn}"
  }
}

variable "hello1_path_patterns" {
  type    = "list"
  default = ["/hello1/*", "/hello1"]
}

resource "aws_lb_listener_rule" "hello1_forward" {
  count        = "${length(var.hello1_path_patterns)}"
  listener_arn = "${aws_lb_listener.front_end.arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.hello1_lambda_tg.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["${element(var.hello1_path_patterns, count.index)}"]
  }
}

resource "aws_lambda_permission" "hello1_with_lb" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.hello1.arn}"
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = "${aws_lb_target_group.hello1_lambda_tg.arn}"
}

resource "aws_lb_target_group" "hello1_lambda_tg" {
  name        = "alb-hello1-lambda-tg"
  target_type = "lambda"
}

resource "aws_lb_target_group_attachment" "hello1_lb_tg_attachment" {
  target_group_arn = "${aws_lb_target_group.hello1_lambda_tg.arn}"
  target_id        = "${aws_lambda_function.hello1.arn}"
  depends_on       = ["aws_lambda_permission.hello1_with_lb"]
}

variable "hello2_path_patterns" {
  type    = "list"
  default = ["/hello2/*", "/hello2"]
}

resource "aws_lb_listener_rule" "hello2_forward" {
  count        = "${length(var.hello2_path_patterns)}"
  listener_arn = "${aws_lb_listener.front_end.arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.hello2_lambda_tg.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["${element(var.hello2_path_patterns, count.index)}"]
  }
}

resource "aws_lambda_permission" "hello2_with_lb" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.hello2.arn}"
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = "${aws_lb_target_group.hello2_lambda_tg.arn}"
}

resource "aws_lb_target_group" "hello2_lambda_tg" {
  name        = "alb-hello2-lambda-tg"
  target_type = "lambda"
}

resource "aws_lb_target_group_attachment" "hello2_lb_tg_attachment" {
  target_group_arn = "${aws_lb_target_group.hello2_lambda_tg.arn}"
  target_id        = "${aws_lambda_function.hello2.arn}"
  depends_on       = ["aws_lambda_permission.hello2_with_lb"]
}

### ECS

resource "aws_lb_target_group" "fargate_app" {
    name = "fun-app-fargate-tg"
    port = 80
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = "${data.aws_vpc.default.id}"
}
