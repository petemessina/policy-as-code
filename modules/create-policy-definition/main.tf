locals {
  policy_data = jsondecode(file("${var.policy_file_location}"))
}

resource "azurerm_policy_definition" "policy_definition" {
  name          = local.policy_data.name
  policy_type   = "Custom"
  mode          = local.policy_data.properties.mode
  display_name  = local.policy_data.properties.displayName
  description   = local.policy_data.properties.description

  metadata      = jsonencode(local.policy_data.properties.metadata)
  policy_rule   = jsonencode(local.policy_data.properties.policyRule)
  parameters    = jsonencode(local.policy_data.properties.parameters)
}