data "tencentcloud_clb_instances" "ingress_ip" {
  count = var.enabled && var.enabled_nginx_ingress_controller ? 1 : 0

  clb_name   = "${tencentcloud_kubernetes_cluster.managed_cluster.0.id}_kube-system_nginx-ingress-controller"
  depends_on = [helm_release.nginx_ingress_controller]
}

resource "helm_release" "nginx_ingress_controller" {
  count = var.enabled && var.enabled_nginx_ingress_controller ? 1 : 0

  name       = "nginx-ingress-controller"
  chart      = "nginx-ingress-controller"
  repository = "https://charts.bitnami.com/bitnami"
  namespace  = "kube-system"
  wait       = true
  version    = var.nginx_ingress_controller_chart_version != "latest" ? var.nginx_ingress_controller_chart_version : null

  set {
    name  = "publishService.enabled"
    value = "true"
  }

  set {
    name  = "ingressClassResource.default"
    value = "true"
    type  = "string"
  }

  set {
    name  = "config.use-gzip"
    value = "true"
    type  = "string"
  }

  set {
    name  = "config.use-http2"
    value = "true"
    type  = "string"
  }

  set {
    name  = "config.proxy-body-size"
    value = "100m"
    type  = "string"
  }

  set {
    name  = "service.annotations.service\\.cloud\\.tencent\\.com/direct-access"
    value = "true"
    type  = "string"
  }

  set {
    name  = "config.enable-underscores-in-headers"
    value = "true"
    type  = "string"
  }

  set {
    name  = "config.keep-alive-requests"
    value = "1000"
    type  = "string"
  }

  set {
    name  = "config.proxy-read-timeout"
    value = "90"
    type  = "string"
  }

  set {
    name  = "config.proxy-send-timeout"
    value = "90"
    type  = "string"
  }

  set {
    name  = "config.keep-alive"
    value = "120"
    type  = "string"
  }

  depends_on = [
    time_sleep.wait_2m_for_node_pool_updating,
    tencentcloud_security_group_lite_rule.tke_apiserver_security_group_lite_rule
  ]
}
