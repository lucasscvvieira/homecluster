stack {
  name        = "Kubernetes Setup"
  description = "Faz a configuração inicial do cluster."

  after = [
    "/stacks/bare/k8s/setup_helm"
  ]
}
