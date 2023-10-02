resource "aws_cloudwatch_log_group" "sample" {
  name              = "/aws/lambda/${var.project}-${var.env}-sample"
  retention_in_days = 7
}
