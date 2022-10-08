variable "shares" {
  type = map(object({
    storage = optional(object({
      request = optional(string, "10Gi")
    }), {})
  }))
}