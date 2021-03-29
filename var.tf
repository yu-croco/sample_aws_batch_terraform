variable "region" {
  type    = string
  default = "ap-northeast-1"
}

locals {
  az_a = "${var.region}a"
  az_c = "${var.region}c"

  log_group = "/aws/batch/job"

  job_definition = {
    command = ["echo", "hello world"],
    // pull from your ECR
    image = "{AWS_ACCOUNT_ID}.dkr.ecr.{REGION}.amazonaws.com/{MY_IMG}:{TAG}",
    memory = 1024,
    vcpus = 1,
    // see https://github.com/hashicorp/terraform-provider-aws/issues/15560
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        "awslogs-group"         = local.log_group
        "awslogs-region"        = "ap-northeast-1",
      }
    },
    "jobRoleArn": aws_iam_role.job_definition.arn,
  }

  ami_image_id = jsondecode(data.aws_ssm_parameter.ami.value)["image_id"]
  suffix = trim(local.ami_image_id, "ami-")
}
