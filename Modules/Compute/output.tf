output "vmss_id" {
  description = "The resource ID of the VM Scale Set."
  value       = azurerm_linux_virtual_machine_scale_set.main.id
}

