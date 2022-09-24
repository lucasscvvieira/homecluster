generate_hcl "tmgen_remote_state.tf" {
  content {
    data "terraform_remote_state" "k8s_init" {
      backend = "local"

      config = {
        path = "${terramate.stack.path.to_root}/tfstate/stacks/bare/k8s/init/terraform.tfstate"
      }
    }
  }
}
