// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT
// TERRAMATE: originated from generate_hcl block on /stacks/bare/k8s/setup/remote_state.tm.hcl

data "terraform_remote_state" "k8s_init" {
  backend = "local"
  config = {
    path = "../../../../tfstate/stacks/bare/k8s/init/terraform.tfstate"
  }
}
