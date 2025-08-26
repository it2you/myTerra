resource "aws_ecr_repository" "ecr_repo" {
  name         = "${var.prefix}-ecr_repo"
  force_delete = true
}

data "aws_caller_identity" "current" {}

locals {
  ecr_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.prefix}-ecr_repo"
}

resource "aws_ssm_parameter" "ecr" {
  name  = "/${var.prefix}/base/ecr"
  value = local.ecr_url
  type  = "String"
  overwrite = true 
}

resource "local_file" "ecr" {
  filename = "${path.module}/ecr-url.txt"
  content  = local.ecr_url
}

output "repository_base_url" {
  value = local.ecr_url
}
