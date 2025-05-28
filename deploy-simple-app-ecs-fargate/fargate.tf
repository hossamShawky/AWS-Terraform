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
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}

# CloudWatch Log Group with Retention Period
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.project}-logs"
  retention_in_days = 1 # Set retention period (e.g., 1 days)
  tags = {
    Project = var.project
  }
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

      # Environment Variables (direct key-value pairs)
      environment = [
        {
          name  = "ENVIRONMENT"
          value = "development"
        },
        {
          name  = "DEBUG"
          value = "false"
        }
      ]
      # Environment File (stored in S3)
      environmentFiles = [
        {
          value = "arn:aws:s3:::my-bucket/my-app.env"
          type  = "s3"
        }
      ]
      #LOGs
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.project}-logs"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "my-app"
          # "awslogs-create-group"  = "true" # Automatically creates the log group
        }
      }
        # Health Check Configuration
      healthCheck = {
        command = ["CMD-SHELL", "curl -f http://localhost:80/health || exit 1"]
        interval = 30
        timeout = 5
        retries = 3
        startPeriod = 60
      }

    }
  ])
}


# Create Security Group
resource "aws_security_group" "fargate_sg" {
  name        = "${var.project}-fargate-sg"
  description = "Allow HTTP inbound traffic from same cidr only"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
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

# Create Security Group
resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-alb-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  tags = {
    "Name" = "${var.project}-alb-sg"
  }
}

# Create Fargate Service

# resource "aws_ecs_service" "my_service" {
#   name            = "my-service"
#   cluster         = aws_ecs_cluster.ecs_cluster.id
#   task_definition = aws_ecs_task_definition.task_definition.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   network_configuration {
#     subnets          = [aws_subnet.subnet.id]
#     security_groups  = [aws_security_group.fargate_sg.id]
#     assign_public_ip = true
#   }
# }



############## CREATE FARGATE AUTOSCALING & ALB ##################

#create alb
resource "aws_lb" "my_alb" {
  name               = "${var.project}-fargate-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.subnet.id, aws_subnet.subnet2.id] # Replace with your subnet ID
}

# Create ALB Target Group
resource "aws_lb_target_group" "my_target_group" {
  name        = "${var.project}-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Create ALB Listener
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

# Create Fargate Service
resource "aws_ecs_service" "my_alb_service" {
  name            = "my-alb-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet.id, aws_subnet.subnet2.id] # Replace with your subnet ID
    security_groups  = [aws_security_group.fargate_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    container_name   = "my-app-container"
    container_port   = 80
  }
}