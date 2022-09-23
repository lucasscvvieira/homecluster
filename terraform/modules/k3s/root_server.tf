resource "ssh_resource" "root_server_create" {
  when         = "create"
  host         = local.root_server_node.host
  user         = local.root_server_node.user
  bastion_host = local.root_server_node.bastion
  agent        = true

  timeout = "15m"
  commands = [
    join(" ", compact([
      "curl -sfL https://get.k3s.io |",
      "INSTALL_K3S_VERSION=${local.k3s_version}",
      "K3S_KUBECONFIG_MODE=664",
      "K3S_TOKEN=${random_password.server_token.result}",
      "K3S_AGENT_TOKEN=${random_password.agent_token.result}",
      local.root_server_node.name != null ? "K3S_NODE_NAME=${local.root_server_node.name}" : "",
      "sh -s - server",
      "--cluster-init",
      # "--write-kubeconfig-mode 664",
      # "--token ${random_password.server_token.result}",
      # "--agent-token ${random_password.agent_token.result}",
      "--flannel-backend ${var.network.flannel_backend}",
      "--cluster-cidr ${var.network.cidr.cluster}",
      "--service-cidr ${var.network.cidr.service}",
      "--cluster-dns ${var.network.dns_ip}",
      "--cluster-domain ${var.network.domain}",
      "%{for label in local.root_server_node.labels~} --node-label ${label} %{endfor~}",
      "%{for taint in local.root_server_node.taints~} --node-taint ${taint} %{endfor~}",
      length(local.disabled_services) > 0 ? "--disable ${local.disabled_services}" : "",
    ]))
  ]

  triggers = {
    for k, v in [
      local.root_server_node.user,
      local.root_server_node.bastion,
    ] : k => v
  }
}

resource "ssh_resource" "root_server_destroy" {
  when         = "destroy"
  host         = local.root_server_node.host
  user         = local.root_server_node.user
  bastion_host = local.root_server_node.bastion
  agent        = true

  timeout = "15m"
  commands = [
    "/usr/local/bin/k3s-uninstall.sh",
  ]

  lifecycle {
    replace_triggered_by = [
      ssh_resource.root_server_create.id,
    ]
  }
}
