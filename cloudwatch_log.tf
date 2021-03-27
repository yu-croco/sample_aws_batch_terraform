resource "aws_cloudwatch_log_group" "aws_batch_cloudwatch_log" {
  name = local.log_group
}
