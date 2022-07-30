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

resource "kubernetes_service_account" "example" {
  depends_on = [
    kubernetes_namespace.whatos
  ]
  metadata {
    name      = "${local.aks_name}-whatos-identity"
    namespace = "whatos"
  }
}