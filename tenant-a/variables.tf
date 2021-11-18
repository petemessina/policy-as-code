variable "policy_initiative_name" {
  type        = string
  description = "Name of the policy initiative to apply"
}
variable "management_group_id" {
  type        = string
  description = "Id of the management group"
}
variable "management_group_name" {
  type        = string
  description = "Name of the management group"
}
variable "management_group_scope" {
  type        = string
  description = "Scope of the policy initiative"
}
variable "policy_file_location" {
  type        = string
  description = "Location of the policy file"
}
variable "parameters" {
  type    = any
  default = null
}
variable "location" {
  type        = string
  description = "Location for the managed identity"
}
variable "enforce" {
  type        = bool
  description = "Enforce policy on create"
  default     = false
}
variable "identity" {
  type        = string
  description = "Identity type to use for the policy"
  default     = null
}
