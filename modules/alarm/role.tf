data "aws_caller_identity" "current" {}

resource "aws_iam_role" "lambda_sample" {
  name               = "${var.project}-${var.env}-lambda-sample-role"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda.json

  inline_policy {
    name   = "${var.project}-${var.env}-sample"
    policy = data.aws_iam_policy_document.sample.json
  }
}

data "aws_iam_policy_document" "sample" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.sample.arn}:*",
    ]
  }
}

data "aws_iam_policy_document" "assume_lambda" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
