resource "aws_db_subnet_group" "private" {
  name       = "dms-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

# trivy:ignore:avd-aws-0077  low backup retention
# trivy:ignore:avd-aws-0080  storage encryption
# trivy:ignore:avd-aws-0133  insights
# trivy:ignore:avd-aws-0176  iam auth
# trivy:ignore:avd-aws-0177  deletion protection
resource "aws_db_instance" "dms" {
  identifier     = "dms"
  engine         = "postgres"
  engine_version = "17.4"
  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 20
  storage_type          = "gp2"

  db_name  = var.database_name
  username = var.database_user
  password = var.master_password

  multi_az               = false
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.dms_source.id]
  db_subnet_group_name   = aws_db_subnet_group.private.name

  parameter_group_name = aws_db_parameter_group.postgres_dms.name

  skip_final_snapshot = true
}

resource "aws_db_parameter_group" "postgres_dms" {
  family = "postgres17"
  name   = "postgres-dms-params"

  parameter {
    name         = "rds.logical_replication"
    value        = "1"
    apply_method = "pending-reboot"
  }
}
