locals {
  policy_set_data = jsondecode(file(var.policy_file_location))
}

resource "azurerm_policy_set_definition" "policy_set_definition" {
  name                  = local.policy_set_data.name
  policy_type           = "Custom"
  display_name          = local.policy_set_data.properties.displayName
  description           = local.policy_set_data.properties.description
  management_group_name = var.management_group_name
  
  metadata     = jsonencode(local.policy_set_data.properties.metadata)
  parameters   = jsonencode(local.policy_set_data.properties.parameters)

  dynamic "policy_definition_reference" {
    for_each = [
      for item in local.policy_set_data.properties.policyDefinitions :
      {
        policyDefinitionId          = item.policyDefinitionId
        parameters                  = try(jsonencode(item.parameters), null)
        policyDefinitionReferenceId = try(item.policyDefinitionReferenceId, null)
      }
    ]
    content {
      policy_definition_id = policy_definition_reference.value["policyDefinitionId"]
      parameter_values     = policy_definition_reference.value["parameters"]
      reference_id         = policy_definition_reference.value["policyDefinitionReferenceId"]
    }
  }
}

# Get Reference to policy initiative
data "azurerm_policy_set_definition" "policy_set_definition" {
  name                    = azurerm_policy_set_definition.policy_set_definition.name
  management_group_name   = var.management_group_scope
  depends_on = [
    azurerm_policy_set_definition.policy_set_definition,
  ]
}

# Execute local module to deploy policy
module "management-policy" {
  source = "../assign-management-group-policy"

  policy_name            = var.policy_initiative_name
  policy_definition_id   = data.azurerm_policy_set_definition.policy_set_definition.id
  management_group_id    = var.management_group_id
  enforce                = var.enforce
  location               = var.location
  parameters             = var.parameters
  identity               = var.identity
}