data "azurerm_policy_definition" "allowed_locations" {
  name = "AllowedLocations"
}

resource "azurerm_policy_assignment" "location_restriction" {
  name                 = "restrict-locations"
  scope                = azurerm_resource_group.rg.id
  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id
  parameters = <<PARAMS
    {
      "listOfAllowedLocations": {
        "value": ["eastus","canadacentral"]
      }
    }
  PARAMS
}
