resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "hello1" {
  filename = "../lambda_functions/hello1.zip"
  function_name = "hello1"
  role = "${aws_iam_role.iam_for_lambda.arn}"
  handler = "main.index"

  source_code_hash = "${filebase64sha256("../lambda_functions/hello1.zip")}"

  runtime = "python3.7"
}

resource "aws_lambda_function" "hello2" {
  filename = "../lambda_functions/hello2.zip"
  function_name = "hello2"
  role = "${aws_iam_role.iam_for_lambda.arn}"
  handler = "main.index"

  source_code_hash = "${filebase64sha256("../lambda_functions/hello2.zip")}"

  runtime = "python3.7"
}