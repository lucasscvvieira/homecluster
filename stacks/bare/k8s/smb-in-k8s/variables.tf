variable "shares" {
  type = map(object({
    storage = optional(object({
      request = optional(string, "10Gi")
    }), {})
    users = list(object({
      username = string
      password = string
    }))
  }))

  validation {
    condition     = alltrue([for share in var.shares : length(share.users) > 0])
    error_message = "Precisa pelo menos um usuário."
  }
}