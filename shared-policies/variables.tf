variable "log_analytics_subscription_id" {
  type        = string
  description = "Subscription Id of the log analytics workspace"
}

variable "log_analytics_resource_group_name" {
  type        = string
  description = "Resource group name of the log analytics workspace"
}

variable "log_analytics_name" {
  type        = string
  description = "Log analytics name of the log analytics workspace"
}

variable "management_group_id" {
  type        = string
  description = "Id of the management group"
}

variable "management_group_name" {
  type        = string
  description = "Name of the management group"
}

variable "enforce" {
  type        = bool
  description = "Enforce policy on create"
  default     = false
}

variable "location" {
  type        = string
  description = "Location for the managed identity"
}