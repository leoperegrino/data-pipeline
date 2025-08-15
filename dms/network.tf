# trivy:ignore:avd-aws-0178  vpc_logs
resource "aws_vpc" "dms" {
  cidr_block = "10.10.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.dms.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.dms.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = false
}

resource "aws_security_group" "dms_source" {
  description = "Security group for the source"
  name        = "dms-source"
  vpc_id      = aws_vpc.dms.id
}

resource "aws_vpc_security_group_ingress_rule" "dms_source_5432_ingress" {
  description       = "Allow port 5432 inbound traffic"
  security_group_id = aws_security_group.dms_source.id

  from_port   = "5432"
  to_port     = "5432"
  ip_protocol = "tcp"
  cidr_ipv4   = "10.10.0.0/16"

}

resource "aws_security_group" "dms_instance" {
  description = "Security group for DMS instance"
  name        = "dms-instance"
  vpc_id      = aws_vpc.dms.id
}

resource "aws_vpc_security_group_egress_rule" "dms_instance_5432_egress" {
  description       = "Allow port 5432 outbound traffic"
  security_group_id = aws_security_group.dms_instance.id

  from_port   = "5432"
  to_port     = "5432"
  ip_protocol = "tcp"
  cidr_ipv4   = "10.10.0.0/16"
}
