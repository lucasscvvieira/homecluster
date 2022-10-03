generate_hcl "tmgen_provider.tf" {
  content {
    terraform {
      backend "local" {
        path = "${terramate.stack.path.to_root}/tfstate/stacks/bare/k8s/setup_helm/terraform.tfstate"
      }

      required_providers {
        helm = {
          source  = "hashicorp/helm"
          version = ">= 2.6.0, < 3.0.0"
        }
        kubernetes = {
          source  = "hashicorp/kubernetes"
          version = ">= 2.13.1, < 3.0.0"
        }
      }
    }

    provider "helm" {
      kubernetes {
        host = data.terraform_remote_state.k8s_init.outputs.kube_conf.cluster.host

        cluster_ca_certificate = data.terraform_remote_state.k8s_init.outputs.kube_conf.cluster.ca_certificate
        client_certificate     = data.terraform_remote_state.k8s_init.outputs.kube_conf.client.certificate
        client_key             = data.terraform_remote_state.k8s_init.outputs.kube_conf.client.key
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
