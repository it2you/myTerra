resource "aws_ecs_cluster" "ecs_cluster" {
	name = "${var.prefix}-ecs-cluster"
}

resource "aws_ecs_task_definition" "ecs_td" {
	family                   = "image-task"
	network_mode             = "awsvpc"
	requires_compatibilities = ["FARGATE"]
	cpu                      = "256"
	memory                   = "512"
	execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

	#set image and port of container
	container_definitions    = jsonencode([
		{
			name      = "my-app-container"
			image     = "${local.ecr_url}:10.4"
			essential = true
			portMappings = [
				{
					containerPort = 80
					hostPort      = 80
					protocol = "tcp"
				},
				{
					containerPort = 8000
					hostPort      = 8000
					protocol = "tcp"
				}
			]
		}
	])
}

#service
resource "aws_ecs_service" "ecs_td" {
	name            = "${var.prefix}-app-service"
	cluster         = aws_ecs_cluster.ecs_cluster.id
	task_definition = aws_ecs_task_definition.ecs_td.arn
	desired_count   = 1
	launch_type     = "FARGATE"
	network_configuration {
		subnets          = [aws_subnet.public_subnet_a.id]
		assign_public_ip = true
		security_groups  = [aws_security_group.front_end_sg.id]
	}
	depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role]
}

resource "aws_iam_role" "ecs_task_execution_role" {
	name = "ecsTaskExecutionRole1"
	assume_role_policy = jsonencode({
		Version = "2012-10-17"
		Statement = [
			{
				Action = "sts:AssumeRole"
				Effect = "Allow"
				Principal = {
					Service = "ecs-tasks.amazonaws.com"
				}
			}
		]
	})
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
	role       = aws_iam_role.ecs_task_execution_role.name
	policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


