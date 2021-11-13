locals {
  policy_rule = jsondecode(data.azurerm_policy_definition.policy_definition.policy_rule)
}

# Get Reference to policy initiative
data "azurerm_policy_definition" "policy_definition" {
  name                    = var.policy_definition_uuid
  management_group_name   = var.management_group_name
}

# Execute local module to deploy policy
module "assign_management_policy" {
  source = "../assign-management-group-policy"

  policy_name            = var.policy_definition_name
  policy_definition_id   = data.azurerm_policy_definition.policy_definition.id
  management_group_id    = var.management_group_id
  enforce                = var.enforce
  location               = var.location
  parameters             = var.parameters
  identity               = var.identity
}

# Add in role assignments from the policy definition
resource "azurerm_role_assignment" "role_assignment" {
  for_each = local.policy_rule.then != null && local.policy_rule.then.details != null && local.policy_rule.then.details.roleDefinitionIds != null ? toset(local.policy_rule.then.details.roleDefinitionIds) : []

  role_definition_id = each.value
  scope              = var.management_group_id
  principal_id       = module.assign_management_policy.identity != null ? module.assign_management_policy.identity[0].principal_id : null
}

#TODO: ADD LINK TO DOCUMENTATION
