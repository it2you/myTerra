data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "nIAM" {
  name               = "${var.prefix}-nIAM"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "ecr_read_attach" {
  role       = aws_iam_role.nIAM.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_instance_profile" "nIAM" {
  name = "${var.prefix}-nIAM"
  role = aws_iam_role.nIAM.name
}
