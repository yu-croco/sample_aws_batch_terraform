// https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended"
}

// if you want to update AMI, terraform replace resource
// https://docs.aws.amazon.com/batch/latest/userguide/compute_environments.html#managed_compute_environments
resource "aws_batch_compute_environment" "aws-batch-computing-environment" {
  // compute_environment_name should be unique.
  // due to `create_before_destroy` life cycle, new resource will be created at first,
  // so need to create unique name resource.
  compute_environment_name = "aws-batch-compute-env-${local.suffix}"
  service_role = aws_iam_role.aws-batch-service-role.arn
  type = "MANAGED"
  state = "ENABLED"

  compute_resources {
    //  https://docs.aws.amazon.com/batch/latest/userguide/allocation-strategies.html
    allocation_strategy = "BEST_FIT"
    instance_role = aws_iam_instance_profile.aws-batch-instance-role.arn
    instance_type = ["c4.large"]
    max_vcpus = 16
    min_vcpus = 0
    security_group_ids = [aws_security_group.aws_batch.id]
    subnets = aws_subnet.private_1a_aws_batch
    type = "EC2"
    image_id = local.ami_image_id
  }

  // when you delete resource, aws_batch_compute_environment gets stuck...
  // work around is to manage iam role on different life cycle... maybe
  // https://github.com/hashicorp/terraform-provider-aws/issues/8549
  depends_on = [aws_iam_role.aws-batch-service-role]

  // job queue needs at least one aws_batch_compute_environment
  lifecycle {
    create_before_destroy = true
  }
}

