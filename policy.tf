# 1. Create a custom copy in your RG
resource "azurerm_policy_definition" "allowed_locations_rg" {
  name         = "AllowedLocationsRG"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed Locations (RG copy)"
  description  = "Restrict locations at RG level"

  policy_rule = <<RULE
  {
    "if": {
      "field": "location",
      "notIn": ["eastus", "canadacentral"]
    },
    "then": { "effect": "deny" }
  }
  RULE
}

# 2. Assign that definition within the same RG
resource "azurerm_resource_group_policy_assignment" "restrict_locations" {
  name                 = "restrict-locations"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = azurerm_policy_definition.allowed_locations_rg.id

  parameters = <<PARAMS
  {}
  PARAMS

  display_name = "Restrict allowed regions"
  description  = "Only eastus or canadacentral in this RG"
}
