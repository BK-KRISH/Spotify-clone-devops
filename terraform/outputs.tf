output "public_ip" {
  value = aws_instance.spotify_server.public_ip
}

output "ssh_command" {
  value = "ssh ubuntu@${aws_instance.spotify_server.public_ip}"
}