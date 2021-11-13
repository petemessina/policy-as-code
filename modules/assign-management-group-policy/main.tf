# Deploy Azure Management Policiy
resource "azurerm_management_group_policy_assignment" "assign_manamgement_policy" {
  name                 = var.policy_name
  policy_definition_id = var.policy_definition_id
  management_group_id  = var.management_group_id
  enforce              = var.enforce
  parameters           = var.parameters != null ? jsonencode(var.parameters) : null
  location             = var.location

  dynamic "identity" {
    for_each = var.identity != null ? ["identity"] : []
    content {
      type = var.identity
    }
  }
}