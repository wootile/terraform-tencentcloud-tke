locals {
  auto_renew_flag = var.auto_renew_flag == 1 ? "NOTIFY_AND_AUTO_RENEW" : "NOTIFY_AND_MANUAL_RENEW"
}

resource "tencentcloud_security_group" "tke_apiserver_security_group" {
  count       = var.enabled ? 1 : 0
  name        = join("-", [var.cluster_name, "apiserver-sg"])
  description = "${var.cluster_name} api-server security group"
}

resource "tencentcloud_security_group_lite_rule" "tke_apiserver_security_group_lite_rule" {
  count             = var.enabled ? 1 : 0
  security_group_id = tencentcloud_security_group.tke_apiserver_security_group.0.id
  ingress = flatten([
    [for i in var.cluster_endpoint_ingress_cidrs : "ACCEPT#${i}#443#TCP"]
  ])
  egress = [
    "ACCEPT#0.0.0.0/0#ALL#ALL",
  ]
}

resource "tencentcloud_kubernetes_cluster" "managed_cluster" {
  count               = var.enabled ? 1 : 0
  cluster_name        = var.cluster_name
  cluster_desc        = "${var.cluster_name} cluster"
  cluster_version     = var.cluster_version
  container_runtime   = var.container_runtime
  service_cidr        = var.service_cidr
  cluster_os          = "tlinux3.1x86_64"
  cluster_deploy_type = "MANAGED_CLUSTER"

  vpc_id                          = var.vpc_id
  eni_subnet_ids                  = var.eni_subnets
  network_type                    = "VPC-CNI"
  cluster_max_service_num         = 1024
  cluster_max_pod_num             = 128
  cluster_internet                = var.cluster_endpoint_public_access
  cluster_internet_security_group = tencentcloud_security_group.tke_apiserver_security_group.0.id

  worker_config {
    count                                   = lookup(var.fixed_node, "desired_capacity", 0)
    availability_zone                       = var.availability_zones[0]
    subnet_id                               = var.subnets[0]
    key_ids                                 = length(var.key_pair_id) > 0 ? [var.key_pair_id] : null
    instance_type                           = lookup(var.fixed_node, "instance_type", "SA2.XLARGE16")
    system_disk_type                        = lookup(var.fixed_node, "system_disk_type", "CLOUD_SSD")
    system_disk_size                        = lookup(var.fixed_node, "system_disk_size", 80)
    internet_charge_type                    = "TRAFFIC_POSTPAID_BY_HOUR"
    public_ip_assigned                      = false
    enhanced_security_service               = false
    enhanced_monitor_service                = false
    instance_charge_type                    = lookup(var.fixed_node, "charge_type", "POSTPAID") == "POSTPAID" ? "POSTPAID_BY_HOUR" : lookup(var.fixed_node, "charge_type", "POSTPAID_BY_HOUR")
    instance_charge_type_prepaid_period     = lookup(var.fixed_node, "charge_type", "POSTPAID") == "PREPAID" ? var.prepaid_period : null
    instance_charge_type_prepaid_renew_flag = lookup(var.fixed_node, "charge_type", "POSTPAID") == "PREPAID" ? local.auto_renew_flag : null
  }

  labels = var.tags
}

resource "tencentcloud_security_group" "tke_worker_security_group" {
  count       = var.enabled ? 1 : 0
  name        = join("-", [var.cluster_name, "worker-sg"])
  description = "${var.cluster_name} worker security group"
}

resource "tencentcloud_security_group_lite_rule" "tke_worker_security_group_lite_rule" {
  count             = var.enabled ? 1 : 0
  security_group_id = tencentcloud_security_group.tke_worker_security_group.0.id
  ingress = flatten([
    "ACCEPT#0.0.0.0/0#ALL#ICMP",
    "ACCEPT#10.200.0.0/16#ALL#ALL",
    [for i in var.worker_allow_ingress_cidrs : "ACCEPT#${i}#${join(",", var.worker_allow_ingress_ports)}#TCP"],
    [for i in var.worker_allow_ingress_cidrs : "ACCEPT#${i}#22#TCP"],
    [for i in var.worker_allow_ingress_cidrs : "ACCEPT#${i}#30000-32768#TCP"],
    [for i in var.worker_allow_ingress_cidrs : "ACCEPT#${i}#30000-32768#UDP"],
  ])
  egress = [
    "ACCEPT#0.0.0.0/0#ALL#ALL",
  ]
}

resource "local_sensitive_file" "kubeconfig" {
  count = var.enabled ? 1 : 0

  content = tencentcloud_kubernetes_cluster.managed_cluster.0.kube_config
  filename = format(
    "%s/%s%s",
    var.secrets_path,
    replace(var.cluster_name, "-", "_"),
    "_kubeconfig.yaml"
  )
  file_permission = "0600"
}

resource "time_sleep" "wait_2m_for_node_pool_updating" {
  count           = var.enabled ? 1 : 0
  create_duration = "2m"

  triggers = {
    tke_id = tencentcloud_kubernetes_cluster.managed_cluster.0.id
  }
}

resource "tencentcloud_kubernetes_node_pool" "this" {
  for_each = { for k, v in var.node_pools : k => v if var.enabled }

  name                     = try(each.value.name, each.key)
  cluster_id               = tencentcloud_kubernetes_cluster.managed_cluster.0.id
  max_size                 = try(each.value.max_size, var.node_pool_defaults.max_size, 10)
  desired_capacity         = try(each.value.desired_size, var.node_pool_defaults.desired_size, 1)
  min_size                 = try(each.value.min_size, var.node_pool_defaults.min_size, 1)
  delete_keep_instance     = false
  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnets
  retry_policy             = "INCREMENTAL_INTERVALS"
  node_os                  = try(each.value.node_os, var.node_pool_defaults.node_os, "tlinux3.1x86_64")
  enable_auto_scale        = try(each.value.enable_auto_scale, var.node_pool_defaults.enable_auto_scale, false)
  multi_zone_subnet_policy = "EQUALITY"

  auto_scaling_config {
    instance_type              = try(each.value.instance_type, var.node_pool_defaults.instance_type, null)
    system_disk_type           = "CLOUD_PREMIUM"
    system_disk_size           = try(each.value.system_disk_size, var.node_pool_defaults.system_disk_size, 100)
    public_ip_assigned         = false
    internet_charge_type       = "TRAFFIC_POSTPAID_BY_HOUR"
    orderly_security_group_ids = [tencentcloud_security_group.tke_worker_security_group.0.id]
    key_ids                    = length(var.key_pair_id) > 0 ? [var.key_pair_id] : null
    enhanced_security_service  = false
    enhanced_monitor_service   = false

    instance_charge_type                    = try(each.value.charge_type, "POSTPAID") == "POSTPAID" ? "POSTPAID_BY_HOUR" : try(each.value.charge_type, "POSTPAID_BY_HOUR")
    instance_charge_type_prepaid_period     = try(each.value.charge_type, "POSTPAID") == "PREPAID" ? var.prepaid_period : null
    instance_charge_type_prepaid_renew_flag = try(each.value.charge_type, "POSTPAID") == "PREPAID" ? local.auto_renew_flag : null

  }

  labels = try(each.value.labels, var.node_pool_defaults.labels, {})
  tags   = merge(var.tags, try(each.value.tags, var.node_pool_defaults.tags, {}))

  dynamic "taints" {
    for_each = try(each.value.taints, var.node_pool_defaults.taints, [])

    content {
      key    = try(taints.value.key, null)
      value  = try(taints.value.value, null)
      effect = try(taints.value.effect, null)
    }
  }

}
