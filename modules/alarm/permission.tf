resource "aws_lambda_permission" "sample" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sample.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.sample.arn
}
