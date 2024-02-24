output "cluster_id" {
  value = module.tke.cluster_id
}

output "cluster_ingress_ip" {
  value = module.tke.cluster_ingress_ip
}

output "kubeconfig" {
  value     = module.tke.kubeconfig
  sensitive = true
}

output "cluster_endpoint" {
  value = module.tke.cluster_endpoint
}

output "cluster_ca_certificate" {
  value = module.tke.cluster_ca_certificate
}

output "client_certificate" {
  value = module.tke.client_certificate
}

output "client_key" {
  value     = module.tke.client_key
  sensitive = true
}
