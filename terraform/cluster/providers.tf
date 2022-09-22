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
  }
}

provider "ssh" {}

provider "random" {}
