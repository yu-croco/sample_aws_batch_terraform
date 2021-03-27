resource "aws_batch_job_queue" "this" {
  name                 = "job queue"
  state                = "ENABLED"
  priority             = 1
  compute_environments = aws_batch_compute_environment.aws-batch-computing-environment.arn
}
