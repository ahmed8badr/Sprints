resource "aws_ecr_repository" "jenkins-ecr" {
  name = "jenkins"
  image_tag_mutability = "MUTABLE"
}

output "ecr_ip" {
  value = aws_ecr_repository.jenkins-ecr.repository_url
}