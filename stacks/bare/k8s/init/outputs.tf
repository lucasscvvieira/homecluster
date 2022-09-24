locals {
  kube_conf = yamldecode(ssh_sensitive_resource.kube_conf.result)
}

output "k3s_version" {
  value = local.k3s_version
}

output "server_nodes" {
  value = var.server_nodes
}

output "agent_nodes" {
  value = var.agent_nodes
}

output "network" {
  value = var.network
}

output "disabled" {
  value = var.disable
}

output "kube_conf" {
  sensitive = true
  value = {
    cluster = {
      host           = "https://${local.primary_server.host}:6443"
      ca_certificate = base64decode(local.kube_conf.clusters[0].cluster.certificate-authority-data)
    }
    client = {
      certificate = base64decode(local.kube_conf.users[0].user.client-certificate-data)
      key         = base64decode(local.kube_conf.users[0].user.client-key-data)
    }
  }
}
