/*
 s3, ecr_dkr, ecr_api and logs are for ECR PrivateLink
 see https://docs.amazonaws.cn/en_us/AmazonECR/latest/userguide/vpc-endpoints.html
*/
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  subnet_ids          = [aws_subnet.private_1a_vpc_endpoint.id, aws_subnet.private_1c_vpc_endpoint.id]
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  subnet_ids = [aws_subnet.private_1a_vpc_endpoint.id, aws_subnet.private_1c_vpc_endpoint.id]
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  subnet_ids = [aws_subnet.private_1a_vpc_endpoint.id, aws_subnet.private_1c_vpc_endpoint.id]
}

/*
  ecs_agent, ecs_telemetry and ecs are for ECS PrivateLink
  see: https://docs.aws.amazon.com/batch/latest/userguide/troubleshooting.html#job_stuck_in_runnable
  see: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/vpc-endpoints.html
*/
resource "aws_vpc_endpoint" "ecs_agent" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ecs-agent"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  subnet_ids          = [aws_subnet.private_1a_vpc_endpoint.id, aws_subnet.private_1c_vpc_endpoint.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecs_telemetry" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ecs-telemetry"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  subnet_ids          = [aws_subnet.private_1a_vpc_endpoint.id, aws_subnet.private_1c_vpc_endpoint.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ecs"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  subnet_ids          = [aws_subnet.private_1a_vpc_endpoint.id, aws_subnet.private_1c_vpc_endpoint.id]
  private_dns_enabled = true
}