output "kms_alias_arn" {
  description = "The ARN of the KMS Alias."
  value       = aws_kms_alias.this.arn
}

output "target_key_arn" {
  description = "The ARN of the target KMS Key."
  value       = aws_kms_alias.this.target_key_arn
}

output "name" {
  description = "The name of the KMS Alias."
  value       = aws_kms_alias.this.name
}
