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

resource "azurerm_federated_identity_credential" "federated_identity_credential" {
  name                = local.workload_id
  resource_group_name = azurerm_resource_group.this.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.this.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.whatos_service_account_identity.id
  subject             = "system:serviceaccount:whatos:${local.workload_id}"
}