locals {
  root_server_node = var.server_nodes[0]
  server_nodes     = slice(var.server_nodes, 1, length(var.server_nodes))
  server_nodes_map = { for node in local.server_nodes : node.host => node }

  disabled_services = join(",", compact([
    var.disable.coredns ? "coredns" : "",
    var.disable.traefik ? "traefik" : "",
    var.disable.metrics_server ? "metrics-server" : "",
    var.disable.servicelb ? "servicelb" : "",
    var.disable.local_storage ? "local-storage" : "",
  ]))
}
