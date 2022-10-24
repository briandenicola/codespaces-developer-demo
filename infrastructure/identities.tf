resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "${local.aks_name}-cluster-identity"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_user_assigned_identity" "aks_kubelet_identity" {
  name                = "${local.aks_name}-kubelet-identity"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_user_assigned_identity" "whatos_service_account_identity" {
  name                = local.workload_id
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azapi_resource" "federated_identity_credential" {
  schema_validation_enabled = false
  name                      = local.workload_id
  parent_id                 = azurerm_user_assigned_identity.whatos_service_account_identity.id
  type                      = "Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2022-01-31-preview"

  location                  = azurerm_resource_group.this.location
  body = jsonencode({
    properties = {
      issuer    = azurerm_kubernetes_cluster.this.oidc_issuer_url
      subject   = "system:serviceaccount:whatos:${local.workload_id}"
      audiences = ["api://AzureADTokenExchange"]
    }
  })
}