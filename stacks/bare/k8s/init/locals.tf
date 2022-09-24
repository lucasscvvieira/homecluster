locals {
  primary_server = var.server_nodes[0]
  server_nodes = {
    for node in slice(var.server_nodes, 1, length(var.server_nodes)) :
    node.host => node
  }

  disabled_services = join(",", [
    for service, enable in var.disable : replace(service, "_", "-")
    if enable
  ])
}
