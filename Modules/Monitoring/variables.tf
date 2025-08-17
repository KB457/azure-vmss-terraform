variable "resource_group_name" {}
variable "location" {}
variable "resource_prefix" {}
variable "retention_days" {}
variable "vmss_id" { type = string }
variable "lb_id"   { type = string }
variable "alert_email" {}
variable "cpu_threshold" {}
variable "cpu_window" {}
variable "metric_namespace" {}
variable "metric_name" {}
variable "metric_aggregation" {}
variable "metric_operator" {}
variable "law_sku" {}
variable "ama_name" {}
variable "ama_publisher" {}
variable "ama_type" {}
variable "ama_version" {}
variable "ama_auto_upgrade" {}
