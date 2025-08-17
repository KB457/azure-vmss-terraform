variable "sub_id" {
  description = "The sub ID"
  type        = string
}

// Network Module

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resource group"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "vnet_adress_space" {
  description = "Address space for the VM"
  type        = list(string)
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "subnet_address_prefixes" {
  description = "Address space for the VM"
  type        = list(string)
}

variable "nic_name" {
  description = "The name of the nic"
  type        = string
}

variable "nsg" {
  description = "The name of the nsg"
  type        = string
}

variable "security_rule_name" {
  description = "The name of the security rule name for SSH"
  type        = string
}

variable "security_rule_name_two" {
  description = "The name of the security rule name for http"
  type        = string
}

variable "public_ip_name" {
  description = "Public IP name"
  type        = string
}

variable "public_ip_allocation" {
  description = "The allocation method for the public IP"
  type        = string
}

variable "ssh_source_address" {
  description = "Public IP address (or CIDR range) allowed to access SSH (22)."
  type        = string
}

variable "http_source_prefix" {
  description = "Source address prefix for HTTP inbound rule."
  type        = string
}

// Compute Module

variable "vmss_name" {
  description = "The name of the Virtual Machine Scale Set"
  type        = string
}

variable "sku_size" {
  description = "The size of the VM"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
}

variable "vmss_instances" {
  description = "The number of instances for the Virtual Machine Scale Set"
  type        = number
}

variable "vmss_zones" {
  description = "Availability Zones for VMSS"
  type        = list(string)
}

variable "admin_name" {
  description = "Admin username"
  type        = string
}

variable "autoscaleproile_name" {
  description = "Autoscale profile name"
  type        = string
}

// ALB Module

variable "alb_name" {
  description = "The azure load balancer name"
  type        = string
}

variable "alb_sku" {
  description = "SKU of the Load Balancer (Basic or Standard)"
  type        = string
}

variable "alb_frontend_name" {
  description = "Frontend configuration name for the Load Balancer"
  type        = string
}

variable "alb_backend_pool_name" {
  description = "Backend address pool name"
  type        = string
}

# Probe settings
variable "alb_probe_name" {
  description = "Name of the load balancer probe"
  type        = string
}

variable "alb_probe_protocol" {
  description = "Protocol used by the probe (Tcp or Http)"
  type        = string
}

variable "alb_probe_port" {
  description = "Port the probe listens on"
  type        = number
}

variable "alb_probe_request_path" {
  description = "Request path for HTTP probe (only for Http protocol)"
  type        = string
}

variable "alb_probe_interval" {
  description = "Interval in seconds between probe attempts"
  type        = number
}

variable "alb_probe_count" {
  description = "Number of probes to consider unhealthy"
  type        = number
}

# Rule settings
variable "alb_rule_name" {
  description = "Name of the load balancer rule"
  type        = string
}

variable "alb_rule_protocol" {
  description = "Protocol for the LB rule (Tcp, Udp)"
  type        = string
}

variable "alb_rule_frontend_port" {
  description = "Frontend port for the LB rule"
  type        = number
}

variable "alb_rule_backend_port" {
  description = "Backend port for the LB rule"
  type        = number
}

variable "alb_disable_outbound_snat" {
  description = "Whether to disable outbound SNAT"
  type        = bool
}

# health

variable "resource_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "storage_account_tier" {
  type        = string
  description = "Storage account performance tier (Standard or Premium)."
}

variable "storage_replication_type" {
  type        = string
  description = "Storage account replication type (LRS, ZRS, GRS, RAGRS, etc)."
}

variable "lb_probe_name" {
  type        = string
  description = "The name of the Load Balancer probe."
}

variable "lb_probe_protocol" {
  type        = string
  description = "Protocol used by the probe (Tcp or Http)."
}

variable "lb_probe_port" {
  type        = number
  description = "The port for the load balancer probe."
}

variable "lb_probe_interval" {
  type        = number
  description = "Interval in seconds between probe attempts."
}

variable "lb_probe_count" {
  type        = number
  description = "Number of probe attempts before marking unhealthy."
}

// monitoring

variable "metric_namespace" {
  type        = string
  description = "Name of metric namespace"
}

variable "metric_name" {
  type        = string
  description = "Name of the metric to monitor"
}

variable "metric_aggregation" {
  type        = string
  description = "Aggregation type (e.g., Average, Total, Maximum)"
}

variable "metric_operator" {
  type        = string
  description = "Comparison operator (GreaterThan, LessThan, etc.)"
}

# --- Log Analytics settings ---
variable "retention_days" {
  type        = number
  description = "Number of days to retain logs in the Log Analytics Workspace. Default = 30 days."
}

variable "law_sku" {
  description = "SKU for Log Analytics Workspace"
  type        = string
}

# Azure Monitor Agent
variable "ama_name" {
  description = "Name of the Azure Monitor Agent extension"
  type        = string
}

variable "ama_publisher" {
  description = "Publisher of the extension"
  type        = string
}

variable "ama_type" {
  description = "Type of extension"
  type        = string
}

variable "ama_version" {
  description = "Handler version for the extension"
  type        = string
}

variable "ama_auto_upgrade" {
  description = "Enable automatic minor version upgrades"
  type        = bool
}

# --- Alert settings ---
variable "alert_email" {
  type        = string
  description = "Email address that will receive alert notifications (via Action Group)."
}

variable "cpu_threshold" {
  type        = number
  description = "CPU usage percentage threshold for triggering an alert. Default = 80%."
}

variable "cpu_window" {
  type        = string
  description = "Time window (ISO 8601 format) over which the CPU usage is evaluated. Default = 5 minutes."
}
