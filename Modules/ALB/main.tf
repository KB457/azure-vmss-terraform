resource "azurerm_lb" "main" {
  name                = var.alb_name
  location            = var.location
  resource_group_name = var.resource_group_name
   sku                 = var.alb_sku

  frontend_ip_configuration {
    name                 = var.alb_frontend_name
    public_ip_address_id = var.public_ip_allocation
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  name            = var.alb_backend_pool_name
  loadbalancer_id = azurerm_lb.main.id
}

resource "azurerm_lb_probe" "http" {
  name            = var.alb_probe_name
  loadbalancer_id = azurerm_lb.main.id
  protocol        = var.alb_probe_protocol
  port            = var.alb_probe_port
  request_path    = var.alb_probe_request_path
  interval_in_seconds = var.alb_probe_interval
  number_of_probes    = var.alb_probe_count
}

resource "azurerm_lb_rule" "http" {
  name                           = var.alb_rule_name
  loadbalancer_id                = azurerm_lb.main.id
  protocol                       = var.alb_rule_protocol
  frontend_port                  = var.alb_rule_frontend_port
  backend_port                   = var.alb_rule_backend_port
  frontend_ip_configuration_name = var.alb_frontend_name
  backend_address_pool_ids      = [azurerm_lb_backend_address_pool.main.id]
  probe_id                       = azurerm_lb_probe.http.id

  # I need this as the same frontend is used by an outbound rule
  disable_outbound_snat = var.alb_disable_outbound_snat


}
# this Gives VMSS instances outbound Internet via the Standard LB
resource "azurerm_lb_outbound_rule" "egress" {
  name                    = "egress"
  loadbalancer_id         = azurerm_lb.main.id
  protocol                = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id

  frontend_ip_configuration {
    name = "public-lb-ip"   # matches my existing frontend name
  }

  idle_timeout_in_minutes  = 4
  enable_tcp_reset         = true
  allocated_outbound_ports = 1024
}

