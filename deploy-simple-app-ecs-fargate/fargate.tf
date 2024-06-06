#Create Repository
resource "aws_ecr_repository" "my_app_repo" {
  name = "${var.project}-registry"
}


#Build Image & Push To ECR
resource "null_resource" "build_push_ecr" {

  provisioner "local-exec" {
    command = "/usr/bin/sh ${path.module}/buildpush.sh"
    environment = {
      AccountID = var.account_number
    }
  }
  depends_on = [aws_ecr_repository.my_app_repo]
}

#Build Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project}-cluster"
  tags = {
    "Name" = "${var.project}-cluster"
  }
}

#Create Task Definition Role

resource "aws_iam_role" "task_execution_role" {
  name = "${var.project}-TD-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}

#Task Definition
resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.project}-taskDefinition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "my-app-container",
      image     = "${aws_ecr_repository.my_app_repo.repository_url}:latest",
      essential = true,
      memory    = 512,
      cpu       = 256,
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80
        }
      ]
    }
  ])
}

# Create Security Group
resource "aws_security_group" "fargate_sg" {
  name        = "${var.project}-fargate-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${var.project}-fargate-sg"
  }
}


# Create Fargate Service
resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet.id]
    security_groups  = [aws_security_group.fargate_sg.id]
    assign_public_ip = true
  }
}