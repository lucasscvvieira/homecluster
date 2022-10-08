locals {
  master_affinity = {
    nodeAffinity = {
      requiredDuringSchedulingIgnoredDuringExecution = {
        nodeSelectorTerms = [{
          matchExpressions = [{
            key      = "node-role.kubernetes.io/master"
            operator = "Exists"
          }]
        }]
      }
    }
  }

  master_tolerations = [{
    key      = "node-role.kubernetes.io/master"
    operator = "Exists"
    effect   = "NoSchedule"
  }]
}
