output "cluster_id" {
  value = var.enabled ? tencentcloud_kubernetes_cluster.managed_cluster.0.id : ""
}

output "cluster_name" {
  value = var.enabled ? tencentcloud_kubernetes_cluster.managed_cluster.0.cluster_name : ""
}

output "cluster_version" {
  value = var.enabled ? tencentcloud_kubernetes_cluster.managed_cluster.0.cluster_version : ""
}

output "cluster_ingress_ip" {
  value = var.enabled && var.enabled_nginx_ingress_controller ? data.tencentcloud_clb_instances.ingress_ip.0.clb_list.0.clb_vips.0 : null
}

output "kubeconfig" {
  value     = var.enabled ? tencentcloud_kubernetes_cluster.managed_cluster.0.kube_config : null
  sensitive = true
}

output "cluster_endpoint" {
  value = var.enabled ? tencentcloud_kubernetes_cluster.managed_cluster.0.cluster_external_endpoint : null
}

output "cluster_ca_certificate" {
  value = var.enabled ? tencentcloud_kubernetes_cluster.managed_cluster.0.certification_authority : null
}

output "client_certificate" {
  value = var.enabled ? base64decode(yamldecode(tencentcloud_kubernetes_cluster.managed_cluster.0.kube_config).users.0.user.client-certificate-data) : null
}

output "client_key" {
  value     = var.enabled ? base64decode(yamldecode(tencentcloud_kubernetes_cluster.managed_cluster.0.kube_config).users.0.user.client-key-data) : null
  sensitive = true
}
