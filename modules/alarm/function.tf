data "archive_file" "sample" {
  type        = "zip"
  source_dir  = "${path.module}/functions/sample"
  output_path = "${path.module}/outputs/sample.zip"
}

resource "aws_lambda_function" "sample" {
  depends_on = [
    aws_cloudwatch_log_group.sample
  ]

  function_name    = "${var.project}-${var.env}-sample"
  runtime          = "python3.10"
  handler          = "main.lambda_handler"
  filename         = data.archive_file.sample.output_path
  source_code_hash = data.archive_file.sample.output_base64sha256
  role             = aws_iam_role.lambda_sample.arn
}
