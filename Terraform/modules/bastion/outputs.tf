output "bastion_id" {
  description = "Bastion EC2 instance ID"
  value       = aws_instance.bastion.id
}

output "bastion_name" {
  description = "Bastion EC2 instance name"
  value       = aws_instance.bastion.tags["Name"]
}

output "bastion_private_ip" {
  description = "Private IP address of the bastion"
  value       = aws_instance.bastion.private_ip
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion"
  value       = aws_instance.bastion.public_ip
}

output "bastion_security_group_id" {
  description = "Security group ID of the bastion"
  value       = aws_security_group.bastion.id
}

output "bastion_iam_role_arn" {
  description = "IAM role ARN attached to the bastion"
  value       = aws_iam_role.bastion.arn
}

output "bastion_instance_profile_name" {
  description = "IAM instance profile attached to the bastion"
  value       = aws_iam_instance_profile.bastion.name
}