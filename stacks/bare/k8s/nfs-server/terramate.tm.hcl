stack {
  name        = "NFS Server in Kubernetes"
  description = "Configura um servidor NFS dentro do Kubernetes."

  after = [
    "/stacks/bare/k8s/setup"
  ]
}
