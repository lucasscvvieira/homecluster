module "k3s_cluster" {
  source = "../modules/k3s"

  disable = {
    coredns        = true
    traefik        = true
    metrics_server = true
    servicelb      = true
    local_storage  = true
  }

  network = {
    flannel_backend = "none"
  }

  server_nodes = [
    {
      host = "192.168.0.101"
      user = "k3s"
    },
  ]

  agent_nodes = [
    {
      host = "192.168.0.102"
      user = "k3s"
    },
  ]
}