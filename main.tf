resource "aws_kms_alias" "this" {
  name          = var.name != null ? join("/", ["alias", var.name]) : null
  name_prefix   = var.name_prefix != null ? join("/", ["alias", var.name_prefix]) : null
  target_key_id = var.target_key_id
}
