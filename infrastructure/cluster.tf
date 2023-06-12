data "azurerm_kubernetes_service_versions" "current" {
  location = azurerm_resource_group.this.location
}

resource "azurerm_kubernetes_cluster" "this" {
  lifecycle {
    ignore_changes = [
      default_node_pool.0.node_count,
    ]
  }
  
  name                              = local.aks_name
  resource_group_name               = azurerm_resource_group.this.name
  location                          = azurerm_resource_group.this.location
  node_resource_group               = "${local.resource_name}_k8s_nodes_rg"
  dns_prefix                        = local.aks_name
  kubernetes_version                = data.azurerm_kubernetes_service_versions.current.latest_version
  sku_tier                          = "Free"
  oidc_issuer_enabled               = true
  workload_identity_enabled         = true
  open_service_mesh_enabled         = true
  azure_policy_enabled              = true
  local_account_disabled            = true
  role_based_access_control_enabled = true
  automatic_channel_upgrade         = "patch"
  image_cleaner_enabled        = true
  image_cleaner_interval_hours = 48

  api_server_access_profile {
    vnet_integration_enabled = true
    subnet_id                = azurerm_subnet.api.id
    authorized_ip_ranges     = ["${chomp(data.http.myip.response_body)}/32"]
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    tenant_id              = data.azurerm_client_config.current.tenant_id
    admin_group_object_ids = [var.azure_rbac_group_object_id]
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.aks_kubelet_identity.client_id
    object_id                 = azurerm_user_assigned_identity.aks_kubelet_identity.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_kubelet_identity.id
  }

  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "Standard_DS4_v2"
    os_disk_size_gb     = 60
    vnet_subnet_id      = azurerm_subnet.nodes.id
    os_sku              = "CBLMariner"
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
    max_pods            = 40

    upgrade_settings {
      max_surge             = "33%"
    }
  }

  network_profile {
    dns_service_ip      = "100.${random_integer.services_cidr.id}.0.10"
    service_cidr        = "100.${random_integer.services_cidr.id}.0.0/16"
    pod_cidr            = "100.${random_integer.pod_cidr.id}.0.0/16"
    network_plugin      = "azure"
    network_plugin_mode = "Overlay"
    network_policy      = "azure"
    load_balancer_sku   = "standard"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  microsoft_defender {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled   = true
    secret_rotation_interval  = "5m"
  }

  web_app_routing {
    dns_zone_id = azurerm_dns_zone.this.id
  }

  auto_scaler_profile {
    max_unready_nodes = "1"
  }

  workload_autoscaler_profile {
    keda_enabled = true
  }

}

data "azurerm_user_assigned_identity" "web_app_routing" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]
  name                = "webapprouting-${local.aks_name}"
  resource_group_name = azurerm_kubernetes_cluster.this.node_resource_group
}

data "azurerm_public_ip" "aks" {
  name                = reverse(split("/", tolist(azurerm_kubernetes_cluster.this.network_profile.0.load_balancer_profile.0.effective_outbound_ips)[0]))[0]
  resource_group_name = azurerm_kubernetes_cluster.this.node_resource_group
}