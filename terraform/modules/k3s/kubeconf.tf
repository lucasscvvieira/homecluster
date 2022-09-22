resource "ssh_sensitive_resource" "kubeconf" {
  when  = "create"
  host  = local.root_server_node.host
  user  = local.root_server_node.user
  agent = true

  timeout = "15m"
  commands = [
    "cat /etc/rancher/k3s/k3s.yaml",
  ]

  depends_on = [
    ssh_resource.root_server_create,
  ]

  lifecycle {
    replace_triggered_by = [
      ssh_resource.root_server_create,
    ]
  }
}
