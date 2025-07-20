
resource "azurerm_resource_group_policy_assignment" "location_restriction" {
  name                = "restrict-locations"
  resource_group_id     = azurerm_resource_group.rg.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/AllowedLocations"


  parameters = <<PARAMS
    {
      "listOfAllowedLocations": {
        "value": ["eastus","canadacentral"]
      }
    }
  PARAMS
}
