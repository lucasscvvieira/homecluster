locals {
  agent_nodes_map = { for node in var.agent_nodes : node.host => node }
}

resource "ssh_resource" "agent_create" {
  for_each = local.agent_nodes_map

  when         = "create"
  host         = each.key
  user         = each.value.user
  bastion_host = each.value.bastion
  agent        = true

  timeout = "15m"
  commands = [
    join(" ", compact([
      "curl -sfL https://get.k3s.io |",
      "K3S_TOKEN=${random_password.agent_token.result}",
      "K3S_URL=https://${local.root_server_node.host}:6443",
      each.value.name != null ? "K3S_NODE_NAME=${each.value.name}" : "",
      "sh -s - agent",
      "%{for label in each.value.labels~} --node-label ${label} %{endfor~}",
      "%{for taint in each.value.taints~} --node-taint ${taint} %{endfor~}",
      # each.key != local.root_server_node.host ? "--server https://${local.root_server_node.host}:6443" : "",
    ]))
  ]

  triggers = {
    for k, v in [each.value.user, each.value.bastion] : k => v
  }

  depends_on = [
    ssh_resource.root_server_create,
  ]

  lifecycle {
    replace_triggered_by = [
      ssh_resource.root_server_create.id,
    ]
  }
}

resource "ssh_resource" "agent_destroy" {
  for_each = local.agent_nodes_map

  when         = "destroy"
  host         = each.key
  user         = each.value.user
  bastion_host = each.value.bastion
  agent        = true

  timeout = "15m"
  commands = [
    "/usr/local/bin/k3s-agent-uninstall.sh",
  ]

  lifecycle {
    replace_triggered_by = [
      ssh_resource.agent_create[each.key].id,
    ]
  }
}
