output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.shopsphere.name
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = aws_eks_cluster.shopsphere.arn
}

output "cluster_endpoint" {
  description = "EKS Kubernetes API endpoint"
  value       = aws_eks_cluster.shopsphere.endpoint
  sensitive   = true
}

output "cluster_version" {
  description = "Kubernetes version"
  value       = aws_eks_cluster.shopsphere.version
}

output "application_node_group" {
  description = "Application node group name"
  value       = aws_eks_node_group.application.node_group_name
}

output "system_node_group" {
  description = "System node group name"
  value       = aws_eks_node_group.system.node_group_name
}

output "cluster_role_arn" {
  description = "IAM role ARN used by the EKS control plane"
  value       = aws_iam_role.eks_cluster.arn
}

output "node_role_arn" {
  description = "IAM role ARN used by EKS worker nodes"
  value       = aws_iam_role.eks_nodes.arn
}

output "cluster_security_group_id" {
  description = "EKS cluster security group ID used by the control plane and managed nodes"
  value       = aws_eks_cluster.shopsphere.vpc_config[0].cluster_security_group_id
}

output "eks_nodes_security_group_id" {
  description = "Security group ID for EKS worker nodes"
  value       = aws_security_group.eks_nodes.id
}

output "shopsphere_pod_role_arn" {
  description = "ARN of the IAM role used by ShopSphere application pods"
  value       = aws_iam_role.shopsphere_pod.arn
}