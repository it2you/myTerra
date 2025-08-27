resource "aws_security_group" "ssh_access" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.prefix}-ssh_access"
  description = "SSH access group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "Allow HTTP"
    createdBy = "it2you-${var.prefix}"
  }
}

resource "aws_security_group" "front_end_sg" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.prefix}-front_end"
  description = "Security group for front_end"

  tags = {
    Name      = "SG for front_end"
    createdBy = "it2you-${var.prefix}"
  }
}

# Allow all outbound connections
resource "aws_security_group_rule" "front_end_all_out" {
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.front_end_sg.id
}

# Allow public access to the front-end server
resource "aws_security_group_rule" "front_end" {
  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.front_end_sg.id
}

resource "aws_security_group_rule" "myapp_front_end" {
  type        = "ingress"
  from_port   = 8000
  to_port     = 8000
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.front_end_sg.id
}

# Allow public access to the grafana server
# docker run -d --name=grafana -p 3000:3000 grafana/grafana

resource "aws_security_group_rule" "grafana_front_end" {
  type        = "ingress"
  from_port   = 3000
  to_port     = 3000
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.front_end_sg.id
}
### end of front-end

resource "aws_security_group_rule" "for_alb" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.front_end_sg.id
}
### end of front-end

