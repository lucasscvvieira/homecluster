stack {
  name        = "Samba in Kubernetes"
  description = "Configura um servidor Samba dentro do Kubernetes."

  after = [
    "/stacks/bare/k8s/setup"
  ]
}
