resource "aws_db_instance" "postgresql_db" {
  identifier            = "my-postgresql-db" 
  instance_class        = "db.t3.micro"       
  engine                = "postgres"                       
  allocated_storage     = 20                  
  storage_type          = "gp2"            
  publicly_accessible   = false               
  db_subnet_group_name  = aws_db_subnet_group.postgresql_subnet_group.name
  skip_final_snapshot   = false
  final_snapshot_identifier = "my-postgresql-db-final-snapshot"
  iam_database_authentication_enabled = true

  username              = jsondecode(data.aws_secretsmanager_secret_version.postgresql_credentials.secret_string)["username"]
  password              = jsondecode(data.aws_secretsmanager_secret_version.postgresql_credentials.secret_string)["password"]

  vpc_security_group_ids = [aws_security_group.postgresql_sg.id]
}

resource "aws_db_subnet_group" "postgresql_subnet_group" {
  name       = "postgresql-subnet-group"
  subnet_ids = values(aws_subnet.private_subnets)[*].id
}


