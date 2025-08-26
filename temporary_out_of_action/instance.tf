resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.prefix}"
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


  availability_zone = "${var.region}a"

  subnet_id = aws_subnet.public_subnet_a.id

  vpc_security_group_ids = [
    "${aws_security_group.front_end_sg.id}",
    "${aws_security_group.ssh_access.id}"
  ]

  tags = {
    Name      = "${var.prefix}" 
    createdBy = "it2you-${var.prefix}"
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
      /home/ec2-user/provision.sh --region ${var.region} --docker-image ${local.ecr_url}:latest 
EOF
    ]
  }
}

