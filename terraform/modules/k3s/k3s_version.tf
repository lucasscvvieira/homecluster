data "http" "k3s_channels" {
  url = "https://update.k3s.io/v1-release/channels"
}

locals {
  k3s_channels = {
    for obj in jsondecode(data.http.k3s_channels.response_body).data : obj.id => obj.latest
    if contains(["stable", "latest", "testing"], obj.id)
  }

  k3s_version = var.k3s_version != null ? var.k3s_version : local.k3s_channels[var.k3s_channel]
}
