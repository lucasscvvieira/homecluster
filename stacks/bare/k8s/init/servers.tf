resource "ssh_resource" "servers_create" {
  for_each = local.server_nodes

  when         = "create"
  host         = each.key
  user         = each.value.user
  bastion_host = each.value.bastion
  agent        = true

  timeout = "15m"
  commands = [
    join(" ", compact([
      "curl -sfL https://get.k3s.io |",
      "INSTALL_K3S_VERSION=${local.k3s_version}",
      "K3S_KUBECONFIG_MODE=664",
      "K3S_TOKEN=${random_password.server_token.result}",
      "K3S_AGENT_TOKEN=${random_password.agent_token.result}",
      "K3S_URL=https://${local.primary_server.host}:6443",
      try("K3S_NODE_NAME=${each.value.name}", ""),
      "sh -s - server",
      "--flannel-backend ${var.network.flannel_backend}",
      "--cluster-cidr ${var.network.cidr.cluster}",
      "--service-cidr ${var.network.cidr.service}",
      "--cluster-dns ${var.network.dns_ip}",
      "--cluster-domain ${var.network.domain}",
      "%{for label in each.value.labels~} --node-label \"${label}\" %{endfor~}",
      "%{for taint in each.value.taints~} --node-taint \"${taint}\" %{endfor~}",
      length(local.disabled_services) > 0 ? "--disable ${local.disabled_services}" : "",
    ]))
  ]

  triggers = {
    for k, v in [each.value.user, each.value.bastion] : k => v
  }

  depends_on = [
    ssh_resource.primary_server_create,
  ]

  lifecycle {
    replace_triggered_by = [
      ssh_resource.primary_server_create.id,
    ]
  }
}

resource "ssh_resource" "servers_destroy" {
  for_each = local.server_nodes

  when         = "destroy"
  host         = each.key
  user         = each.value.user
  bastion_host = each.value.bastion
  agent        = true

  timeout = "15m"
  commands = [
    "/usr/local/bin/k3s-uninstall.sh",
  ]

  lifecycle {
    replace_triggered_by = [
      ssh_resource.servers_create[each.key].id,
    ]
  }
}
