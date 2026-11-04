# Optional language block
language {
  # Specifies that this symbol library is written for the first experimental version of the symbol library language.
  edition = experimental2026
}

# Define a type
typedef "dns_recordset" {
  type = object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  })
}
# Due to restrictions in HCL, types are referenced using the `::` namespaced function syntax.
# Referenced within the library as symbols::dns_recordset()
# Referenced outside the symbol library as symbols::<libname>::dns_recordset()


# Define a function 
function "format_dns_recordset" {
  # Optional specification of the expected return type
  type = string
  
  # Optional
  description = "Formats the dns record as plain text"
  
  # Named parameters with a given type, these are similar to the "variable" concept within OpenTofu modules and have many of the same options
  parameter "in" {
    type = symbols::dns_recordset()
    # variadic = true may be specified to capture all subsequent arguments into the parameter as a list
    # Optional validation block
    validation {
      condition = length(param.in.records) != 0
      error_message = "Expected at least one record"
    }
  }
  
  # Locals are local to a call of the function and can be used
  # to prepare the return value in multiple steps for clarity
  locals {
    entries = [for record in param.in.records : "record_set ${param.in.name} is a ${param.in.type} with a ttl of ${param.in.ttl} and entry \"${record}\""]
    str = join("\n", local.entries)
  }
  
  # The final value of the function is specified by the return attribute
  return = local.str
}
# Called within the library as symbols::format_dns_recordset(value)
# Called outside the symbol library as symbols::<libname>::format_dns_recordset(value)


# Values are exported constants
values {
  example_recordset = { name = "Example", type = "A", ttl = 500, records = ["example.com. 600 IN A 10.10.10.10"]}
}
# Referenced within the library as symbols.example_recordset
# Referenced outside the symbol library as symbols.<libname>.example_recordset

