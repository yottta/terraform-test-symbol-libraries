# Optional language block
language {
  # Specifies that this symbol library is written for the first experimental version of the symbol library language.
  edition = experimental2026
}

typedef "my_type" {
  type = object({
    name    = string
  })
}
