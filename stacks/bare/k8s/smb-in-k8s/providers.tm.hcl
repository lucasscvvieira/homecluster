generate_hcl "tmgen_provider.tf" {
  content {
    terraform {
      backend "local" {
        path = "${terramate.stack.path.to_root}/tfstate/stacks/bare/k8s/smb-in-k8s/terraform.tfstate"
      }

      required_providers {
        kubernetes = {
          source  = "hashicorp/kubernetes"
          version = ">= 2.13.1, < 3.0.0"
        }
      }
    }

    provider "kubernetes" {
      host = data.terraform_remote_state.k8s_init.outputs.kube_conf.cluster.host

      cluster_ca_certificate = data.terraform_remote_state.k8s_init.outputs.kube_conf.cluster.ca_certificate
      client_certificate     = data.terraform_remote_state.k8s_init.outputs.kube_conf.client.certificate
      client_key             = data.terraform_remote_state.k8s_init.outputs.kube_conf.client.key
    }
  }
}
