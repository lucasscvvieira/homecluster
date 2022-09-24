// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT
// TERRAMATE: originated from generate_hcl block on /stacks/bare/k8s/init/provider.tm.hcl

terraform {
  backend "local" {
    path = "../../../../tfstate/stacks/bare/k8s/init/terraform.tfstate"
  }
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = ">= 3.1.0, < 4.0.0"
    }
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
provider "ssh" {
}
provider "random" {
}
provider "http" {
}
