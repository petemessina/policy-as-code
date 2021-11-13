# Get Reference to policy initiative
data "azurerm_policy_set_definition" "policy_set_definition" {
  name                    = var.policy_initiative_uuid
  management_group_name   = var.management_group_scope
}

# Execute local module to deploy policy
module "assign_management-policy" {
  source = "../assign-management-group-policy"

  policy_name            = var.policy_initiative_name
  policy_definition_id   = data.azurerm_policy_set_definition.policy_set_definition.id
  management_group_id    = var.management_group_id
  enforce                = var.enforce
  location               = var.location
  parameters             = var.parameters
  identity               = var.identity
}