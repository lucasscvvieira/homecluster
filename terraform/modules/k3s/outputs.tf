locals {
  kubeconf = yamldecode(ssh_sensitive_resource.kubeconf.result)
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

output "kubeconf" {
  value = {
    cluster = {
      host           = "https://${local.root_server_node.host}:6443"
      ca_certificate = base64decode(local.kubeconf.clusters[0].cluster.certificate-authority-data)
    }
    client = {
      certificate = base64decode(local.kubeconf.users[0].user.client-certificate-data)
      key         = base64decode(local.kubeconf.users[0].user.client-key-data)
    }
  }
  sensitive = true
}
