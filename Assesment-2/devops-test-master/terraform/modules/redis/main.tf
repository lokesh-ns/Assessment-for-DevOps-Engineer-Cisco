resource "aws_security_group" "redis" {
  name        = "${var.project}-${var.environment}-redis-sg"
  description = "Allow Redis access from ECS only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [var.ecs_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project}-${var.environment}-redis-sg" }
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.project}-${var.environment}-redis-subnet-group"
  subnet_ids = [var.private_subnet_1_id, var.private_subnet_2_id]
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id       = "${var.project}-${var.environment}-redis"
  description                = "Redis for ${var.project}-${var.environment}"
  node_type                  = "cache.t3.micro"
  num_cache_clusters         = 2
  port                       = 6379
  parameter_group_name       = "default.redis7"
  engine_version             = "7.0"
  subnet_group_name          = aws_elasticache_subnet_group.this.name
  security_group_ids         = [aws_security_group.redis.id]
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  automatic_failover_enabled = true

  tags = { Name = "${var.project}-${var.environment}-redis" }
}