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
    createdBy = "infra-${var.prefix}/news"
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.prefix}-news"
  public_key = file("${path.module}/id_rsa.pub")
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["137112412989"] #amazon
}

### Front end

resource "aws_security_group" "front_end_sg" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.prefix}-front_end"
  description = "Security group for front_end"

  tags = {
    Name      = "SG for front_end"
    createdBy = "infra-${var.prefix}/news"
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

resource "aws_instance" "front_end" {
  #count = 3
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh_key.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }

#  iam_instance_profile = "${var.prefix}-news_host"

  availability_zone = "${var.region}a"

  subnet_id = aws_subnet.public_subnet_a.id

  vpc_security_group_ids = [
    "${aws_security_group.front_end_sg.id}",
    "${aws_security_group.ssh_access.id}"
  ]

  tags = {
    Name      = "${var.prefix}" #-${count.index}"
    createdBy = "infra-${var.prefix}"
  }

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.module}/id_rsa")
  }

  provisioner "file" {
    source      = "${path.module}/docker-compose.yml"
    destination = "/home/ec2-user/docker-compose.yml"
  }

  provisioner "remote-exec" {
    script = "${path.module}/provision-docker.sh"
  }
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
### end of front-end

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


resource "null_resource" "front_end_provision" {
  connection {
    host        = aws_instance.front_end.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.module}/id_rsa")
  }
  provisioner "file" {
    source      = "${path.module}/provision-app.sh"
    destination = "/home/ec2-user/provision.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ec2-user/provision.sh ",
      <<EOF
      /home/ec2-user/provision.sh --region ${var.region} --docker-image ${local.ecr_url}front_end:latest 
EOF
    ]
  }
}

