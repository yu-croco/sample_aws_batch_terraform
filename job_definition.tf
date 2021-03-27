resource "aws_batch_job_definition" "job_definition" {
  name = "job definition"
  type = "container"
  container_properties = data.template_file.job-definition.rendered
}

data "template_file" "job-definition" {
  template = jsonencode(local.job_definition)
}
