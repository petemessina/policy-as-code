# Define local variables
locals {
  #Array defining the initiatives to create on the management group
  /*
  NOTE: 
  1. The length of the name needs to be between 3 - 24 characters. This is for
     display purposes in the portal.
  2. Parameters are key value pairs and an example is below
  "azure_security_benchmark" = {
      "name"       = "Azure Security Benchmark",
      "parameters" = {
        "param1" = {
          "value" = "VALUE"
        }, 
        "param2" = {
          "value" = "VALUE"
        }
      }
    }
  }
  */
  policity_initiatives = {
    "azure_security_benchmark" = {
      "name"                    = "Azure Security Benchmark",
      "uuid"                    = "1f3afdf9-d0c9-4c3d-847f-89da613e70a8",
      "management_group_name"   = null,
      "management_group_scope"  = null,
      "identity"                = null,
      "parameters" = null
    }
  }
  custom_policity_initiatives = {
    "diagnostic_settings" = {
      "name"                    = "Diagnostic Settings",
      "file_location"           = "../policy-definitions/initiatives/org_diag_settings.json",
      "management_group_name"   = var.management_group_name,
      "management_group_scope"  = var.management_group_name,
      "identity"                = "SystemAssigned",
      "parameters" = {
        "log_analytics_workspace" = {
          "value" = "53375b8e-d9be-4ae9-82a1-f8993546edce"
        }
      }
    }
  }
  policy_definitions = {
  "configure_activity_logs" = {
      "name"                    = "Configure Activity Logs",
      "uuid"                    = "2465583e-4e78-4c15-b6be-a36cbc7c8b0f",
      "management_group_name"   = null,
      "management_group_scope"  = null,
      "identity"                = "SystemAssigned",
      "parameters" = {
        "logAnalytics" = {
          "value" = "/subscriptions/${var.log_analytics_subscription_id}/resourcegroups/${var.log_analytics_resource_group_name}/providers/microsoft.operationalinsights/workspaces/${var.log_analytics_name}"
        }
      }
    },
    "secrity_center_export" = {
      "name"                    = "Security Center Export"
      "uuid"                    = "ffb6f416-7bd2-4488-8828-56585fef2be9",
      "management_group_name"   = null,
      "management_group_scope"  = null,
      "identity"                = "SystemAssigned",
      "parameters" = {
        "resourceGroupName" = {
          "value" = var.log_analytics_resource_group_name
        },
        "resourceGroupLocation" = {
          "value" = "East US"
        },
        "workspaceResourceId" = {
          "value" = "/subscriptions/${var.log_analytics_subscription_id}/resourcegroups/${var.log_analytics_resource_group_name}/providers/microsoft.operationalinsights/workspaces/${var.log_analytics_name}"
        }
      }
    }
  }
}

#TODO: Policies to support: Enable Defender, set or audit diagnostic settings, Security Benchmark, NSG Rules,
# Azure AD Sign in Logs(Require AD Logs to be Exported), Subscription Activity Logs, Security Center Export(Continues Export)
# User access administrator - can delegate contributor

# Deploy initiative to tenant
module "assign_policy_set" {
  for_each               = local.policity_initiatives
  source                 = "../modules/assign-policy-set"
  
  policy_initiative_name = each.value.name
  policy_initiative_uuid = each.value.uuid
  management_group_id    = var.management_group_id
  management_group_name  = each.value.management_group_name
  management_group_scope = each.value.management_group_scope
  enforce                = var.enforce
  location               = var.location
  identity               = each.value.identity 
  parameters             = each.value.parameters
}

module "create_policy_set" {
  for_each               = local.custom_policity_initiatives
  source                 = "../modules/create-policy-set"
  
  policy_initiative_name = each.value.name
  policy_file_location   = each.value.file_location
  management_group_id    = var.management_group_id
  management_group_name  = each.value.management_group_name
  management_group_scope = each.value.management_group_scope
  enforce                = var.enforce
  location               = var.location
  identity               = each.value.identity 
  parameters             = each.value.parameters
}

module "assign_policy_definition" {
  for_each               = local.policy_definitions
  source                 = "../modules/assign-policy-definition"
  
  policy_definition_name = each.value.name
  policy_definition_uuid = each.value.uuid
  management_group_id    = var.management_group_id
  management_group_name  = each.value.management_group_name
  enforce                = var.enforce
  location               = var.location
  identity               = each.value.identity
  parameters             = each.value.parameters
}

#TODO: ADD IN DEFINITION