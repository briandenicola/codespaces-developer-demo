variable "azure_rbac_group_object_id" {
  description = "GUID of the AKS admin Group"
  default     = "15390134-7115-49f3-8375-da9f6f608dce"
}

variable "production" {
  default     = false
}

variable "region" {
  default     = "southcentralus"
  description = "The Azure region to deploy to"
}