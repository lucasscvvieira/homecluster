// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT
// TERRAMATE: originated from generate_hcl block on /stacks/bare/k8s/setup_helm/providers.tm.hcl

terraform {
  backend "local" {
    path = "../../../../tfstate/stacks/bare/k8s/setup_helm/terraform.tfstate"
  }
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0, < 3.0.0"
    }
  }
}
provider "helm" {
  kubernetes {
    client_certificate     = data.terraform_remote_state.k8s_init.outputs.kube_conf.client.certificate
    client_key             = data.terraform_remote_state.k8s_init.outputs.kube_conf.client.key
    cluster_ca_certificate = data.terraform_remote_state.k8s_init.outputs.kube_conf.cluster.ca_certificate
    host                   = data.terraform_remote_state.k8s_init.outputs.kube_conf.cluster.host
  }
}