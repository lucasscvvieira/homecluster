stack {
  name        = "Kubernetes Setup Helm"
  description = "Instala todos os helms para fazer a configuração inicial do cluster."

  after = [
    "/stacks/bare/k8s/init"
  ]
}
