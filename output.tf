output "ssh_cli" {
  value = "ssh ec2-user@${aws_instance.front_end.public_ip} -i id_rsa"
}

output "hosts_file_entry" {
  value = "${aws_instance.front_end.public_ip} mywebsite"
}

output "frontend_url" {
  value = "http://mywebsite:8080"
}
