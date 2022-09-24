resource "ssh_sensitive_resource" "kube_conf" {
  when  = "create"
  host  = local.primary_server.host
  user  = local.primary_server.user
  agent = true

  timeout = "15m"
  commands = [
    "cat /etc/rancher/k3s/k3s.yaml",
  ]

  depends_on = [
    ssh_resource.primary_server_create,
  ]

  lifecycle {
    replace_triggered_by = [
      ssh_resource.primary_server_create.id,
    ]
  }
}
