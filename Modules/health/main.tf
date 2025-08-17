resource "azurerm_lb_probe" "http_health" {
  name                = var.lb_probe_name
  loadbalancer_id     = var.lb_id
  protocol            = var.lb_probe_protocol
  port                = var.lb_probe_port
  interval_in_seconds = var.lb_probe_interval
  number_of_probes    = var.lb_probe_count
}
# Boot Diagnostics Storage Account
resource "azurerm_storage_account" "diag" {
  name                     = "${var.resource_prefix}diagstorage0199501"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type
}

