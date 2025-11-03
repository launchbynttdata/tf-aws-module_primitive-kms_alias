variable "name" {
  description = "The name of the resource."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with 'name'."
  type        = string
  default     = null
}

variable "target_key_id" {
  description = "(Required) Identifier for the key for which the alias is for, can be either an ARN or key_id."
  type        = string
}


check "name_or_prefix" {
  assert {
    condition     = !(var.name != null && var.name_prefix != null)
    error_message = "Only one of 'name' or 'name_prefix' can be specified."
  }
}
