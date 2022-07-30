output "AKS_RESOURCE_GROUP" {
    value = azurerm_kubernetes_cluster.this.resource_group_name
    sensitive = true
}

output "AKS_CLUSTER_NAME" {
    value = azurerm_kubernetes_cluster.this.name
    sensitive = false
}

output "ACR_NAME" {
    value = azurerm_container_registry.this.login_server
    sensitive = false
}

output "CERTIFICATE_KV_URI" {
    value = azurerm_key_vault_certificate.this.secret_id
    sensitive = false
}

output "APPLICATION_URI" {
    value = "https://api.${local.resource_name}.local"
    sensitive = false
}

output "WORKLOAD_IDENTITY" {
    value = azuread_application.this.application_id
    sensitive = false
}