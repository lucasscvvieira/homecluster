generate_hcl "tmgen_provider.tf" {
  content {
    terraform {
      backend "local" {
        path = "${terramate.stack.path.to_root}/tfstate/stacks/bare/k8s/init/terraform.tfstate"
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
      }
    }

    provider "ssh" {}
    provider "random" {}
    provider "http" {}
  }
}
