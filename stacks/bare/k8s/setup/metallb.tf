resource "kubernetes_manifest" "metallb_ipaddresspool" {
  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "IPAddressPool"
    metadata = {
      name      = "production"
      namespace = "metallb-system"
    }
    spec = {
      addresses = ["192.168.0.48/29"]
    }
  }
}

resource "kubernetes_manifest" "metallb_l2advertisement" {
  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "L2Advertisement"
    metadata = {
      name      = "production"
      namespace = "metallb-system"
    }
  }
}
