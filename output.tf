output "repository_base_url" {
  value = local.ecr_url
}
output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value = "http://${aws_alb.application_load_balancer.dns_name}"

}
