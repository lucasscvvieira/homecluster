resource "ssh_resource" "primary_server_create" {
  when         = "create"
  host         = local.primary_server.host
  user         = local.primary_server.user
  bastion_host = local.primary_server.bastion
  agent        = true

  timeout = "15m"
  commands = [
    join(" ", compact([
      "curl -sfL https://get.k3s.io |",
      "INSTALL_K3S_VERSION=${local.k3s_version}",
      "K3S_KUBECONFIG_MODE=664",
      "K3S_TOKEN=${random_password.server_token.result}",
      "K3S_AGENT_TOKEN=${random_password.agent_token.result}",
      try("K3S_NODE_NAME=${local.primary_server.name}", ""),
      "sh -s - server --cluster-init",
      "--flannel-backend ${var.network.flannel_backend}",
      "--cluster-cidr ${var.network.cidr.cluster}",
      "--service-cidr ${var.network.cidr.service}",
      "--cluster-dns ${var.network.dns_ip}",
      "--cluster-domain ${var.network.domain}",
      "%{for label in local.primary_server.labels~} --node-label \"${label}\" %{endfor~}",
      "%{for taint in local.primary_server.taints~} --node-taint \"${taint}\" %{endfor~}",
      length(local.disabled_services) > 0 ? "--disable ${local.disabled_services}" : "",
    ]))
  ]

  triggers = {
    for k, v in [
      local.primary_server.user, local.primary_server.bastion,
    ] : k => v
  }
}

resource "ssh_resource" "primary_server_destroy" {
  when         = "destroy"
  host         = local.primary_server.host
  user         = local.primary_server.user
  bastion_host = local.primary_server.bastion
  agent        = true

  timeout = "15m"
  commands = [
    "/usr/local/bin/k3s-uninstall.sh",
  ]

  lifecycle {
    replace_triggered_by = [
      ssh_resource.primary_server_create.id,
    ]
  }
}
