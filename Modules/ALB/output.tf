output "backend_address_pool_id" {
  value = azurerm_lb_backend_address_pool.main.id
}
output "lb_id" {
  description = "ID of the Load Balancer"
  value       = azurerm_lb.main.id
}
