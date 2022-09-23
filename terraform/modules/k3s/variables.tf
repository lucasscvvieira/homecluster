variable "k3s_version" {
  type = string
  default = null
  nullable = true
}

variable "k3s_channel" {
  type = string
  default = "stable"
}

variable "server_nodes" {
  type = list(object({
    name    = optional(string)
    host    = string
    user    = string
    bastion = optional(string)
    labels  = optional(list(string), [])
    taints  = optional(list(string), [])
  }))

  validation {
    condition     = length(var.server_nodes) > 0
    error_message = "Need at least 1 server node."
  }
}

variable "agent_nodes" {
  type = list(object({
    name    = optional(string)
    host    = string
    user    = string
    bastion = optional(string)
    labels  = optional(list(string), [])
    taints  = optional(list(string), [])
  }))
  default = []
}

variable "network" {
  type = object({
    dns_ip          = optional(string, "10.43.0.10")
    domain          = optional(string, "cluster.local")
    flannel_backend = optional(string, "vxlan")
    cidr = optional(object({
      cluster = optional(string, "10.42.0.0/16")
      service = optional(string, "10.43.0.0/16")
    }), {})
  })
  default = {}
}

variable "disable" {
  type = object({
    coredns        = optional(bool, false)
    traefik        = optional(bool, false)
    metrics_server = optional(bool, false)
    servicelb      = optional(bool, false)
    local_storage  = optional(bool, false)
  })
  default = {}
}
