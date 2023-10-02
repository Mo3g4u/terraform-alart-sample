resource "aws_sns_topic" "sample" {
  name = "${var.project}-${var.env}-sample"
}

resource "aws_sns_topic_subscription" "sample" {
  topic_arn = aws_sns_topic.sample.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.sample.arn
}
