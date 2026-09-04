resource "aws_security_group" "alb" {

  name = "${var.project_name}-${var.environment}-alb-sg"

  description = "Security group for Application Load Balancer"

  vpc_id = var.vpc_id

  ingress {
    description = "HTTP"

    from_port = var.app_port
    to_port   = var.app_port

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-alb-sg"
    }
  )
}


resource "aws_security_group" "web" {

  name = "${var.project_name}-${var.environment}-web-sg"

  description = "Security group for web servers"

  vpc_id = var.vpc_id

  ingress {
    description = "HTTP from ALB"

    from_port = var.app_port
    to_port   = var.app_port

    protocol = "tcp"

    security_groups = [
      aws_security_group.alb.id
    ]
  }

  dynamic "ingress" {

    for_each = var.ssh_cidr_blocks

    content {

      description = "SSH"

      from_port = 22
      to_port   = 22

      protocol = "tcp"

      cidr_blocks = [
        ingress.value
      ]
    }
  }

  egress {

    description = "Allow outbound traffic"

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-web-sg"
    }
  )
}