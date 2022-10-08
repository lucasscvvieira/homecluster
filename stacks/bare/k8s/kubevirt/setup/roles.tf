resource "kubernetes_cluster_role" "kubevirt_io_operator" {
  metadata {
    name = "kubevirt.io:operator"

    labels = {
      "rbac.authorization.k8s.io/aggregate-to-admin" = "true"
    }
  }

  rule {
    verbs      = ["get", "delete", "create", "update", "patch", "list", "watch", "deletecollection"]
    api_groups = ["kubevirt.io"]
    resources  = ["kubevirts"]
  }
}

resource "kubernetes_role" "kubevirt_operator" {
  metadata {
    name      = "kubevirt-operator"
    namespace = kubernetes_namespace.kubevirt.metadata[0].name
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "patch", "delete"]
    api_groups = [""]
    resources  = ["secrets"]
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "patch", "delete"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "patch", "delete"]
    api_groups = ["route.openshift.io"]
    resources  = ["routes"]
  }

  rule {
    verbs      = ["create"]
    api_groups = ["route.openshift.io"]
    resources  = ["routes/custom-host"]
  }
}

resource "kubernetes_cluster_role" "kubevirt_operator" {
  metadata {
    name = "kubevirt-operator"
  }

  rule {
    verbs      = ["get", "list", "watch", "patch", "update", "patch"]
    api_groups = ["kubevirt.io"]
    resources  = ["kubevirts"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "delete", "patch"]
    api_groups = [""]
    resources  = ["serviceaccounts", "services", "endpoints", "pods/exec"]
  }

  rule {
    verbs      = ["patch", "delete"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete", "patch"]
    api_groups = ["batch"]
    resources  = ["jobs"]
  }

  rule {
    verbs      = ["watch", "list", "create", "delete", "patch"]
    api_groups = ["apps"]
    resources  = ["controllerrevisions"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete", "patch"]
    api_groups = ["apps"]
    resources  = ["deployments", "daemonsets"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete", "patch", "update"]
    api_groups = ["rbac.authorization.k8s.io"]
    resources  = ["clusterroles", "clusterrolebindings", "roles", "rolebindings"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete", "patch"]
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
  }

  rule {
    verbs      = ["create", "get", "list", "watch"]
    api_groups = ["security.openshift.io"]
    resources  = ["securitycontextconstraints"]
  }

  rule {
    verbs          = ["get", "patch", "update"]
    api_groups     = ["security.openshift.io"]
    resources      = ["securitycontextconstraints"]
    resource_names = ["privileged"]
  }

  rule {
    verbs          = ["get", "list", "watch", "update", "delete"]
    api_groups     = ["security.openshift.io"]
    resources      = ["securitycontextconstraints"]
    resource_names = ["kubevirt-handler", "kubevirt-controller"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete", "update", "patch"]
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["validatingwebhookconfigurations", "mutatingwebhookconfigurations"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete", "update", "patch"]
    api_groups = ["apiregistration.k8s.io"]
    resources  = ["apiservices"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete", "update", "patch"]
    api_groups = ["monitoring.coreos.com"]
    resources  = ["servicemonitors", "prometheusrules"]
  }

  rule {
    verbs      = ["get", "list", "watch", "patch"]
    api_groups = [""]
    resources  = ["namespaces"]
  }

  rule {
    verbs      = ["get", "delete", "create", "update", "patch", "list", "watch", "deletecollection"]
    api_groups = ["flavor.kubevirt.io"]
    resources  = ["virtualmachineflavors", "virtualmachineclusterflavors", "virtualmachinepreferences", "virtualmachineclusterpreferences"]
  }

  rule {
    verbs      = ["get", "list", "delete", "patch"]
    api_groups = [""]
    resources  = ["pods"]
  }

  rule {
    verbs      = ["get", "list", "watch", "patch", "update"]
    api_groups = ["kubevirt.io"]
    resources  = ["virtualmachines", "virtualmachineinstances"]
  }

  rule {
    verbs      = ["get"]
    api_groups = [""]
    resources  = ["persistentvolumeclaims"]
  }

  rule {
    verbs      = ["patch"]
    api_groups = ["kubevirt.io"]
    resources  = ["virtualmachines/status"]
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "patch"]
    api_groups = ["kubevirt.io"]
    resources  = ["virtualmachineinstancemigrations"]
  }

  rule {
    verbs      = ["watch", "list"]
    api_groups = ["kubevirt.io"]
    resources  = ["virtualmachineinstancepresets"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["watch", "list"]
    api_groups = [""]
    resources  = ["limitranges"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["kubevirt.io"]
    resources  = ["kubevirts"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["snapshot.kubevirt.io"]
    resources  = ["virtualmachinesnapshots", "virtualmachinerestores"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["cdi.kubevirt.io"]
    resources  = ["datasources"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["instancetype.kubevirt.io"]
    resources  = ["virtualmachineinstancetypes", "virtualmachineclusterinstancetypes", "virtualmachinepreferences", "virtualmachineclusterpreferences"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["migrations.kubevirt.io"]
    resources  = ["migrationpolicies"]
  }

  rule {
    verbs      = ["create", "list", "get"]
    api_groups = ["apps"]
    resources  = ["controllerrevisions"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["get", "list", "watch", "delete", "create", "patch"]
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
  }

  rule {
    verbs      = ["get", "list", "watch", "delete", "update", "create", "patch"]
    api_groups = [""]
    resources  = ["pods", "configmaps", "endpoints", "services"]
  }

  rule {
    verbs      = ["update", "create", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["create"]
    api_groups = [""]
    resources  = ["secrets"]
  }

  rule {
    verbs      = ["update"]
    api_groups = [""]
    resources  = ["pods/finalizers"]
  }

  rule {
    verbs      = ["create"]
    api_groups = [""]
    resources  = ["pods/eviction"]
  }

  rule {
    verbs      = ["patch"]
    api_groups = [""]
    resources  = ["pods/status"]
  }

  rule {
    verbs      = ["get", "list", "watch", "update", "patch"]
    api_groups = [""]
    resources  = ["nodes"]
  }

  rule {
    verbs      = ["list"]
    api_groups = ["apps"]
    resources  = ["daemonsets"]
  }

  rule {
    verbs      = ["watch", "list", "create", "delete", "get"]
    api_groups = ["apps"]
    resources  = ["controllerrevisions"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "delete", "patch"]
    api_groups = [""]
    resources  = ["persistentvolumeclaims"]
  }

  rule {
    verbs      = ["*"]
    api_groups = ["snapshot.kubevirt.io"]
    resources  = ["*"]
  }

  rule {
    verbs      = ["*"]
    api_groups = ["export.kubevirt.io"]
    resources  = ["*"]
  }

  rule {
    verbs      = ["watch", "list", "create", "delete", "update", "patch", "get"]
    api_groups = ["pool.kubevirt.io"]
    resources  = ["virtualmachinepools", "virtualmachinepools/finalizers"]
  }

  rule {
    verbs      = ["*"]
    api_groups = ["kubevirt.io"]
    resources  = ["*"]
  }

  rule {
    verbs      = ["update"]
    api_groups = ["subresources.kubevirt.io"]
    resources  = ["virtualmachineinstances/addvolume", "virtualmachineinstances/removevolume", "virtualmachineinstances/freeze", "virtualmachineinstances/unfreeze", "virtualmachineinstances/softreboot"]
  }

  rule {
    verbs      = ["*"]
    api_groups = ["cdi.kubevirt.io"]
    resources  = ["*"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["k8s.cni.cncf.io"]
    resources  = ["network-attachment-definitions"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
  }

  rule {
    verbs      = ["create"]
    api_groups = ["authorization.k8s.io"]
    resources  = ["subjectaccessreviews"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["snapshot.storage.k8s.io"]
    resources  = ["volumesnapshotclasses"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "delete"]
    api_groups = ["snapshot.storage.k8s.io"]
    resources  = ["volumesnapshots"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["instancetype.kubevirt.io"]
    resources  = ["virtualmachineinstancetypes", "virtualmachineclusterinstancetypes", "virtualmachinepreferences", "virtualmachineclusterpreferences"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["migrations.kubevirt.io"]
    resources  = ["migrationpolicies"]
  }

  rule {
    verbs      = ["get", "list", "watch", "update", "patch", "delete"]
    api_groups = ["clone.kubevirt.io"]
    resources  = ["virtualmachineclones", "virtualmachineclones/status", "virtualmachineclones/finalizers"]
  }

  rule {
    verbs      = ["get"]
    api_groups = [""]
    resources  = ["namespaces"]
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = ["route.openshift.io"]
    resources  = ["routes"]
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = [""]
    resources  = ["secrets"]
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
  }

  rule {
    verbs      = ["update", "list", "watch"]
    api_groups = ["kubevirt.io"]
    resources  = ["virtualmachineinstances"]
  }

  rule {
    verbs      = ["patch", "list", "watch", "get"]
    api_groups = [""]
    resources  = ["nodes"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["kubevirt.io"]
    resources  = ["kubevirts"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["migrations.kubevirt.io"]
    resources  = ["migrationpolicies"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["export.kubevirt.io"]
    resources  = ["virtualmachineexports"]
  }

  rule {
    verbs          = ["get", "list", "watch"]
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["kubevirt-export-ca"]
  }

  rule {
    verbs      = ["get", "list"]
    api_groups = ["subresources.kubevirt.io"]
    resources  = ["version", "guestfs"]
  }

  rule {
    verbs      = ["get"]
    api_groups = ["subresources.kubevirt.io"]
    resources  = ["virtualmachineinstances/console", "virtualmachineinstances/vnc", "virtualmachineinstances/guestosinfo", "virtualmachineinstances/filesystemlist", "virtualmachineinstances/userlist"]
  }

  rule {
    verbs      = ["update"]
    api_groups = ["subresources.kubevirt.io"]
    resources  = ["virtualmachineinstances/pause", "virtualmachineinstances/unpause", "virtualmachineinstances/addvolume", "virtualmachineinstances/removevolume", "virtualmachineinstances/freeze", "virtualmachineinstances/unfreeze", "virtualmachineinstances/softreboot", "virtualmachineinstances/portforward"]
  }

  rule {
    verbs      = ["update"]
    api_groups = ["subresources.kubevirt.io"]
    resources  = ["virtualmachines/start", "virtualmachines/stop", "virtualmachines/restart", "virtualmachines/addvolume", "virtualmachines/removevolume", "virtualmachines/migrate", "virtualmachines/memorydump"]
  }

  rule {
    verbs      = ["get", "delete", "create", "update", "patch", "list", "watch", "deletecollection"]
    api_groups = ["kubevirt.io"]
    resources  = ["virtualmachines", "virtualmachineinstances", "virtualmachineinstancepresets", "virtualmachineinstancereplicasets", "virtualmachineinstancemigrations"]
  }

  rule {
    verbs      = ["get", "delete", "create", "update", "patch", "list", "watch", "deletecollection"]
    api_groups = ["snapshot.kubevirt.io"]
    resources  = ["virtualmachinesnapshots", "virtualmachinesnapshotcontents", "virtualmachinerestores"]
  }

  rule {
    verbs      = ["get", "delete", "create", "update", "patch", "list", "watch", "deletecollection"]
    api_groups = ["instancetype.kubevirt.io"]
    resources  = ["virtualmachineinstancetypes", "virtualmachineclusterinstancetypes", "virtualmachinepreferences", "virtualmachineclusterpreferences"]
  }

  rule {
    verbs      = ["get", "delete", "create", "update", "patch", "list", "watch", "deletecollection"]
    api_groups = ["pool.kubevirt.io"]
    resources  = ["virtualmachinepools"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["migrations.kubevirt.io"]
    resources  = ["migrationpolicies"]
  }

  rule {
    verbs      = ["get"]
    api_groups = ["subresources.kubevirt.io"]
    resources  = ["virtualmachineinstances/console", "virtualmachineinstances/vnc", "virtualmachineinstances/guestosinfo", "virtualmachineinstances/filesystemlist", "virtualmachineinstances/userlist"]
  }

  rule {
    verbs      = ["update"]
    api_groups = ["subresources.kubevirt.io"]
    resources  = ["virtualmachineinstances/pause", "virtualmachineinstances/unpause", "virtualmachineinstances/addvolume", "virtualmachineinstances/removevolume", "virtualmachineinstances/freeze", "virtualmachineinstances/unfreeze", "virtualmachineinstances/softreboot", "virtualmachineinstances/portforward"]
  }

  rule {
    verbs      = ["update"]
    api_groups = ["subresources.kubevirt.io"]
    resources  = ["virtualmachines/start", "virtualmachines/stop", "virtualmachines/restart", "virtualmachines/addvolume", "virtualmachines/removevolume", "virtualmachines/migrate", "virtualmachines/memorydump"]
  }

  rule {
    verbs      = ["get", "delete", "create", "update", "patch", "list", "watch"]
    api_groups = ["kubevirt.io"]
    resources  = ["virtualmachines", "virtualmachineinstances", "virtualmachineinstancepresets", "virtualmachineinstancereplicasets", "virtualmachineinstancemigrations"]
  }

  rule {
    verbs      = ["get", "delete", "create", "update", "patch", "list", "watch"]
    api_groups = ["snapshot.kubevirt.io"]
    resources  = ["virtualmachinesnapshots", "virtualmachinesnapshotcontents", "virtualmachinerestores"]
  }

  rule {
    verbs      = ["get", "delete", "create", "update", "patch", "list", "watch"]
    api_groups = ["instancetype.kubevirt.io"]
    resources  = ["virtualmachineinstancetypes", "virtualmachineclusterinstancetypes", "virtualmachinepreferences", "virtualmachineclusterpreferences"]
  }

  rule {
    verbs      = ["get", "delete", "create", "update", "patch", "list", "watch"]
    api_groups = ["pool.kubevirt.io"]
    resources  = ["virtualmachinepools"]
  }

  rule {
    verbs      = ["get", "list"]
    api_groups = ["kubevirt.io"]
    resources  = ["kubevirts"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["migrations.kubevirt.io"]
    resources  = ["migrationpolicies"]
  }

  rule {
    verbs      = ["get"]
    api_groups = ["subresources.kubevirt.io"]
    resources  = ["virtualmachineinstances/guestosinfo", "virtualmachineinstances/filesystemlist", "virtualmachineinstances/userlist"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["kubevirt.io"]
    resources  = ["virtualmachines", "virtualmachineinstances", "virtualmachineinstancepresets", "virtualmachineinstancereplicasets", "virtualmachineinstancemigrations"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["snapshot.kubevirt.io"]
    resources  = ["virtualmachinesnapshots", "virtualmachinesnapshotcontents", "virtualmachinerestores"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["instancetype.kubevirt.io"]
    resources  = ["virtualmachineinstancetypes", "virtualmachineclusterinstancetypes", "virtualmachinepreferences", "virtualmachineclusterpreferences"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["pool.kubevirt.io"]
    resources  = ["virtualmachinepools"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["migrations.kubevirt.io"]
    resources  = ["migrationpolicies"]
  }

  rule {
    verbs      = ["create"]
    api_groups = ["authentication.k8s.io"]
    resources  = ["tokenreviews"]
  }

  rule {
    verbs      = ["create"]
    api_groups = ["authorization.k8s.io"]
    resources  = ["subjectaccessreviews"]
  }
}