# terraform-tencentcloud-tke

## Example

See also: [examples/complete/main.tf](/examples/complete/main.tf)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.2 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.4.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.8.0 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.67.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.4.1 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.67.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.nginx_ingress_controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [local_sensitive_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [tencentcloud_kubernetes_cluster.managed_cluster](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/kubernetes_cluster) | resource |
| [tencentcloud_kubernetes_node_pool.this](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/kubernetes_node_pool) | resource |
| [tencentcloud_security_group.tke_apiserver_security_group](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/security_group) | resource |
| [tencentcloud_security_group.tke_worker_security_group](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/security_group) | resource |
| [tencentcloud_security_group_lite_rule.tke_apiserver_security_group_lite_rule](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/security_group_lite_rule) | resource |
| [tencentcloud_security_group_lite_rule.tke_worker_security_group_lite_rule](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/security_group_lite_rule) | resource |
| [time_sleep.wait_2m_for_node_pool_updating](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [tencentcloud_clb_instances.ingress_ip](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/data-sources/clb_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_renew_flag"></a> [auto\_renew\_flag](#input\_auto\_renew\_flag) | n/a | `number` | `0` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | n/a | `list(string)` | n/a | yes |
| <a name="input_charge_type"></a> [charge\_type](#input\_charge\_type) | n/a | `string` | `"POSTPAID"` | no |
| <a name="input_cluster_endpoint_ingress_cidrs"></a> [cluster\_endpoint\_ingress\_cidrs](#input\_cluster\_endpoint\_ingress\_cidrs) | n/a | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Indicates whether or not the TKE public API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Cluster name | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | k8s version | `string` | `"1.22.5"` | no |
| <a name="input_container_runtime"></a> [container\_runtime](#input\_container\_runtime) | containerd or docker | `string` | `"containerd"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_enabled_nginx_ingress_controller"></a> [enabled\_nginx\_ingress\_controller](#input\_enabled\_nginx\_ingress\_controller) | n/a | `bool` | `true` | no |
| <a name="input_eni_subnets"></a> [eni\_subnets](#input\_eni\_subnets) | TKE Pod ENI subnet IDs | `list(string)` | n/a | yes |
| <a name="input_fixed_node"></a> [fixed\_node](#input\_fixed\_node) | n/a | `any` | `{}` | no |
| <a name="input_key_pair_id"></a> [key\_pair\_id](#input\_key\_pair\_id) | SSH key Pair ID. | `string` | `""` | no |
| <a name="input_nginx_ingress_controller_chart_version"></a> [nginx\_ingress\_controller\_chart\_version](#input\_nginx\_ingress\_controller\_chart\_version) | n/a | `string` | `"latest"` | no |
| <a name="input_node_pool_defaults"></a> [node\_pool\_defaults](#input\_node\_pool\_defaults) | Map of TKE managed node pool definitions to create | `any` | `{}` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | Map of TKE managed node pool definitions to create | `any` | `{}` | no |
| <a name="input_prepaid_period"></a> [prepaid\_period](#input\_prepaid\_period) | n/a | `number` | `1` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `number` | `0` | no |
| <a name="input_secrets_path"></a> [secrets\_path](#input\_secrets\_path) | n/a | `string` | `"./secrets"` | no |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | n/a | `string` | `"10.0.0.0/22"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | TKE Node subnet IDs | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the project. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | vpc id | `string` | n/a | yes |
| <a name="input_worker_allow_ingress_cidrs"></a> [worker\_allow\_ingress\_cidrs](#input\_worker\_allow\_ingress\_cidrs) | n/a | `list(string)` | `[]` | no |
| <a name="input_worker_allow_ingress_ports"></a> [worker\_allow\_ingress\_ports](#input\_worker\_allow\_ingress\_ports) | n/a | `list(number)` | <pre>[<br>  22<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | n/a |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key) | n/a |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | n/a |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | n/a |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | n/a |
| <a name="output_cluster_ingress_ip"></a> [cluster\_ingress\_ip](#output\_cluster\_ingress\_ip) | n/a |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_cluster_version"></a> [cluster\_version](#output\_cluster\_version) | n/a |
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | n/a |
<!-- END_TF_DOCS -->