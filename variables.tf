variable "enabled" {
  type    = bool
  default = true
}

variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the project."
}

variable "charge_type" {
  type    = string
  default = "POSTPAID"
}

variable "prepaid_period" {
  type    = number
  default = 1
}

variable "auto_renew_flag" {
  type    = number
  default = 0
}

variable "availability_zones" {
  type = list(string)
}

variable "project_id" {
  type    = number
  default = 0
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "subnets" {
  type        = list(string)
  description = "TKE Node subnet IDs"
}

variable "eni_subnets" {
  type        = list(string)
  description = "TKE Pod ENI subnet IDs"
}

variable "worker_allow_ingress_cidrs" {
  type    = list(string)
  default = []
}

variable "cluster_endpoint_ingress_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "key_pair_id" {
  type        = string
  description = "SSH key Pair ID."
  default     = ""
}

variable "secrets_path" {
  type    = string
  default = "./secrets"
}

variable "enabled_nginx_ingress_controller" {
  type    = bool
  default = true
}

variable "nginx_ingress_controller_chart_version" {
  type    = string
  default = "latest"
}

variable "service_cidr" {
  type    = string
  default = "10.0.0.0/22"
}

variable "cluster_version" {
  type        = string
  nullable    = false
  description = "k8s version"
  default     = "1.22.5"
}

variable "container_runtime" {
  type        = string
  nullable    = false
  description = "containerd or docker"
  default     = "containerd"
}

variable "cluster_endpoint_public_access" {
  type        = bool
  description = "Indicates whether or not the TKE public API server endpoint is enabled"
  default     = true
}

variable "fixed_node" {
  type    = any
  default = {}
}

variable "node_pools" {
  description = "Map of TKE managed node pool definitions to create"
  type        = any
  default     = {}
}

variable "node_pool_defaults" {
  description = "Map of TKE managed node pool definitions to create"
  type        = any
  default     = {}
}

variable "worker_allow_ingress_ports" {
  type    = list(number)
  default = [22]
}
