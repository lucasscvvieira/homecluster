resource "kubernetes_manifest" "metallb_ipaddresspool" {
  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "IPAddressPool"
    metadata = {
      name      = "production"
      namespace = "metallb-system"
    }
    spec = {
      addresses = ["10.8.0.200-10.8.0.249"]
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
