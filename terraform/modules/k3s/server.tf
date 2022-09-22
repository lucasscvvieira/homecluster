resource "ssh_resource" "server_create" {
  for_each = local.server_nodes_map

  when         = "create"
  host         = each.key
  user         = each.value.user
  bastion_host = each.value.bastion
  agent        = true

  timeout = "15m"
  commands = [
    join(" ", compact([
      "curl -sfL https://get.k3s.io |",
      "K3S_KUBECONFIG_MODE=664",
      "K3S_TOKEN=${random_password.server_token.result}",
      "K3S_AGENT_TOKEN=${random_password.agent_token.result}",
      "K3S_URL=https://${local.root_server_node.host}:6443",
      each.value.name != null ? "K3S_NODE_NAME=${each.value.name}" : "",
      "sh -s - server",
      # "--write-kubeconfig-mode 664",
      # "--token ${random_password.server_token.result}",
      # "--agent-token ${random_password.agent_token.result}",
      "--flannel-backend ${var.network.flannel_backend}",
      "--cluster-cidr ${var.network.cidr.cluster}",
      "--service-cidr ${var.network.cidr.service}",
      "--cluster-dns ${var.network.dns_ip}",
      "--cluster-domain ${var.network.domain}",
      "%{for label in each.value.labels~} --node-label ${label} %{endfor~}",
      "%{for taint in each.value.taints~} --node-taint ${taint} %{endfor~}",
      # each.key != local.root_server_node.host ? "--server https://${local.root_server_node.host}:6443" : "",
      length(local.disabled_services) > 0 ? "--disable ${local.disabled_services}" : "",
    ]))
  ]

  triggers = {
    for k, v in compact(flatten([
      each.value.user, each.value.labels, each.value.taints,
      local.disabled_services, var.network.flannel_backend,
    ])) : k => v
  }

  depends_on = [
    ssh_resource.root_server_create,
  ]

  lifecycle {
    replace_triggered_by = [
      ssh_resource.root_server_create,
    ]
  }
}

resource "ssh_resource" "server_destroy" {
  for_each = local.server_nodes_map

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
      ssh_resource.server_create[each.key],
    ]
  }
}