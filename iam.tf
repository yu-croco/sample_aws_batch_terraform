/*
  for aws batch job
*/
resource "aws_iam_role" "job_definition" {
  name = "aws-batch-job-definition"
  assume_role_policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com",
      ]
    }
  }
}

// for pulling docker image from ECR
resource "aws_iam_role_policy_attachment" "ecs_task_AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.job_definition.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy" "this" {
  name   = "aws-batch-role-policy"
  role   = aws_iam_role.job_definition.id
  policy = data.aws_iam_policy_document.ecs_task_cloudwatch.json
}

data "aws_iam_policy_document" "ecs_task_cloudwatch" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

/*
  for aws batch compute environment instance role
*/

resource "aws_iam_role" "aws-batch-instance-role" {
  name = "aws-batch-instance-role"
  force_detach_policies = true
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role.json
}

resource "aws_iam_role_policy_attachment" "aws-batch-instance-role" {
  role = aws_iam_role.aws-batch-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "aws-batch-instance-role" {
  name = "aws-batch-instance-profile"
  role = aws_iam_role.aws-batch-instance-role.name
}

data "aws_iam_policy_document" "instance-assume-role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}

/*
  for aws batch compute environment service role
*/

resource "aws_iam_role" "aws-batch-service-role" {
  name = "aws-batch-service-role"
  force_detach_policies = true
  assume_role_policy = data.aws_iam_policy_document.service-assume-role.json
}

resource "aws_iam_role_policy_attachment" "aws-batch-service-role" {
  role = aws_iam_role.aws-batch-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

data "aws_iam_policy_document" "service-assume-role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "batch.amazonaws.com",
      ]
    }
  }
}