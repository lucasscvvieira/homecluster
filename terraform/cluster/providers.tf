terraform {
  backend "local" {
    path = "../tfstate/cluster.tfstate"
  }

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3, < 4.0.0"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = ">= 2.2.1, < 3.0.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.1.0, < 4.0.0"
    }
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

provider "ssh" {
  # Configuration options
}

provider "random" {
  # Configuration options
}

provider "http" {
  # Configuration options
}

provider "helm" {
  kubernetes {
    host = module.k3s_cluster.kubeconf.cluster.host

    cluster_ca_certificate = module.k3s_cluster.kubeconf.cluster.ca_certificate
    client_certificate     = module.k3s_cluster.kubeconf.client.certificate
    client_key             = module.k3s_cluster.kubeconf.client.key
  }
}

provider "kubernetes" {
  host = module.k3s_cluster.kubeconf.cluster.host

  cluster_ca_certificate = module.k3s_cluster.kubeconf.cluster.ca_certificate
  client_certificate     = module.k3s_cluster.kubeconf.client.certificate
  client_key             = module.k3s_cluster.kubeconf.client.key
}
