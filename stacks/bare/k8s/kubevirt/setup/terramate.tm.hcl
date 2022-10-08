stack {
  name        = "KubeVirt Setup"
  description = "Configura o KubeVirt Operator. (v0.57.1)"

  after = [
    "/stacks/bare/k8s/setup"
  ]
}
