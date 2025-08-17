provider "azurerm" {
  features {}
  subscription_id = var.sub_id

}

module "network" {
  source = "./Modules/Network"
  location = var.location
  resource_group_name = var.resource_group_name
  vnet_name = var.vnet_name
  vnet_adress_space = var.vnet_adress_space
  subnet_name = var.subnet_name
  subnet_address_prefixes = var.subnet_address_prefixes
  security_rule_name = var.security_rule_name
  nic_name = var.nic_name
  nsg = var.nsg
  security_rule_name_two = var.security_rule_name_two
  public_ip_name = var.public_ip_name
  public_ip_allocation = var.public_ip_allocation
  ssh_source_address = var.ssh_source_address
  http_source_prefix = var.http_source_prefix
}

module "compute" {
  source = "./Modules/Compute"
  vmss_name = var.vmss_name
  sku_size = var.sku_size
  admin_name = var.admin_name
  vmss_instances = var.vmss_instances
  ssh_public_key_path = var.ssh_public_key_path
  vmss_zones = var.vmss_zones
  subnet_id = module.network.subnet_id
  resource_group_name = module.network.resource_group_name
  location = module.network.location
  backend_address_pool_id     = module.alb.backend_address_pool_id





}

module "alb" {
  source = "./Modules/ALB"
  alb_name = var.alb_name
  resource_group_name = module.network.resource_group_name
  location = module.network.location
  public_ip_allocation = module.network.public_ip_allocation

  alb_sku           = var.alb_sku
  alb_frontend_name = var.alb_frontend_name

  # Backend pool
  alb_backend_pool_name = var.alb_backend_pool_name

  # Probe
  alb_probe_name         = var.alb_probe_name
  alb_probe_protocol     = var.alb_probe_protocol
  alb_probe_port         = var.alb_probe_port
  alb_probe_request_path = var.alb_probe_request_path
  alb_probe_interval     = var.alb_probe_interval
  alb_probe_count        = var.alb_probe_count

  # Rule
  alb_rule_name          = var.alb_rule_name
  alb_rule_protocol      = var.alb_rule_protocol
  alb_rule_frontend_port = var.alb_rule_frontend_port
  alb_rule_backend_port  = var.alb_rule_backend_port
  alb_disable_outbound_snat = var.alb_disable_outbound_snat


}


module "health" {
  source = "./Modules/health"
  lb_id = module.alb.lb_id
  resource_group_name = module.network.resource_group_name
  location            = module.network.location
  resource_prefix = var.resource_prefix
  storage_account_tier = var.storage_account_tier
  storage_replication_type = var.storage_replication_type
  lb_probe_name     = var.lb_probe_name
  lb_probe_protocol = var.lb_probe_protocol
  lb_probe_port     = var.lb_probe_port
  lb_probe_interval = var.lb_probe_interval
  lb_probe_count    = var.lb_probe_count

}

module "monitoring" {
  source              = "./Modules/Monitoring"

  
  resource_group_name = module.network.resource_group_name
  location            = module.network.location
  resource_prefix     = var.resource_prefix


  depends_on = [module.compute]                                  # Ensure VMSS + extensions finish before monitoring (avoids 409 conflicts)

  # IDs coming from my network and alb modules' outputs
  vmss_id = module.compute.vmss_id
  lb_id   = module.alb.lb_id

  # Alert + LAW settings (pass-through from root vars/tfvars)
  alert_email = var.alert_email
  cpu_threshold = var.cpu_threshold
  cpu_window = var.cpu_window
  retention_days = var.retention_days
  law_sku = var.law_sku

  metric_aggregation = var.metric_aggregation
  metric_name = var.metric_name
  metric_namespace = var.metric_namespace
  metric_operator = var.metric_operator

  # Azure Monitor Agent
  ama_name          = var.ama_name
  ama_publisher     = var.ama_publisher
  ama_type          = var.ama_type
  ama_version       = var.ama_version
  ama_auto_upgrade  = var.ama_auto_upgrade
}
