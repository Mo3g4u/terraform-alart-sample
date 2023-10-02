resource "aws_cloudwatch_metric_alarm" "sample" {
  alarm_name         = "${var.project}-${var.env}-AlarmSample"
  alarm_description  = "CPUの負荷をみてLambdaを実行します。"
  evaluation_periods = 1
  namespace          = "AWS/EC2"
  metric_name        = "CPUUtilization"
  dimensions = {
    InstanceId = var.ec2_instance_id
  }
  period              = 60
  statistic           = "Maximum"
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"
  alarm_actions       = [aws_sns_topic.sample.arn]
}
