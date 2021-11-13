variable "policy_name" {
  type        = string
  description = "Name of the policy to show in the portal"
}

variable "policy_definition_id" {
  type        = string
  description = "Id for the policy definition"
}

variable "management_group_id" {
  type        = string
  description = "Id for the management group to apply the policy to"
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