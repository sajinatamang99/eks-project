output "repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.ecr_repo.repository_url
}
output "repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.ecr_repo.arn
}
output "repository_name" {
  description = "ECR repository name"
  value       = aws_ecr_repository.ecr_repo.name
}