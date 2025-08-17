output "health_probe_id" {
  value = azurerm_lb_probe.http_health.id
}

# Output for Boot Diagnostics to connect to VMSS
output "boot_diagnostics_uri" {
  value = azurerm_storage_account.diag.primary_blob_endpoint
}