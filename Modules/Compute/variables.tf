variable "ssh_public_key_path" {}
variable "sku_size" {}
variable "vmss_name" {}
variable "vmss_instances" {}
variable "vmss_zones" {}
variable "admin_name" {}
variable "subnet_id" {
  description = "The ID of the subnet to associate with the VMSS"
  type        = string
}
variable "resource_group_name" {}
variable "location" {}
variable "backend_address_pool_id" {}

