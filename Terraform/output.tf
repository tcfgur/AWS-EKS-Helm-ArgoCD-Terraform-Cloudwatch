output "my_node_role_name" {
  value = aws_iam_role.my_node_role.name
}

output "my_node_role_arn" {
  value = aws_iam_role.my_node_role.arn
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnet_ids" {
  value = [for key, subnet in aws_subnet.private_subnets : subnet.id]
}


output "postgresql_secret_id" {
  value = aws_secretsmanager_secret.postgresql_credentials.id
}
output "aws_iam_openid_connect_provider" {
  value = aws_iam_openid_connect_provider.cluster.arn
}

#output "kubeconfig" {
#  value       = local.kubeconfig
#  description = "kubeconfig for the AWS EKS cluster"
#  sensitive = true
#}
