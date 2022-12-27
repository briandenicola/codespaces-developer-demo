resource "kubernetes_namespace" "whatos" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]
  metadata {
    name = "whatos"
    labels = {
      "openservicemesh.io/monitored-by" = "osm"
    }
    annotations = {
      "openservicemesh.io/sidecar-injection" = "enabled"
    }
  }
}

resource "kubernetes_service_account" "whatos-workload-identity" {
  depends_on = [
    kubernetes_namespace.whatos
  ]
  metadata {
    name      = "${local.resource_name}-sa-identity"
    namespace = "whatos"
    annotations = {
      "azure.workload.identity/client-id" = azurerm_user_assigned_identity.whatos_service_account_identity.client_id
      "azure.workload.identity/tenant-id" = data.azurerm_client_config.current.tenant_id
    }
    labels      = {
      "azure.workload.identity/use"       = "true"
    } 
  }
}

