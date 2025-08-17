variable "alb_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "public_ip_allocation" {}
variable "alb_sku" {}
variable "alb_frontend_name" {}
variable "alb_backend_pool_name" {}

# Probe
variable "alb_probe_name" {}
variable "alb_probe_protocol" {}
variable "alb_probe_port" {}
variable "alb_probe_request_path" {}
variable "alb_probe_interval" {}
variable "alb_probe_count" {}

# Rule
variable "alb_rule_name" {}
variable "alb_rule_protocol" {}
variable "alb_rule_frontend_port" {}
variable "alb_rule_backend_port" {}
variable "alb_disable_outbound_snat" {}
