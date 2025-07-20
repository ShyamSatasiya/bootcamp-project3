

resource "azurerm_resource_group_policy_assignment" "location_restriction" {
  name                = "restrict-locations"
  resource_group_id     = azurerm_resource_group.rg.id
  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id

  parameters = <<PARAMS
    {
      "listOfAllowedLocations": {
        "value": ["eastus","canadacentral"]
      }
    }
  PARAMS
  display_name = "Restrict allowed regions"
  description  = "Only eastus or canadacentral may be used in this resource group"
}
