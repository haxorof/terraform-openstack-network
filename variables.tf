#########
# Network
#########
variable "create" {
  description = "Whether to create network and subnets"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of network"
  type        = string
}

variable "name_prefix" {
  description = "Name prefix of network"
  type        = string
  default     = ""
}

variable "use_name_prefix" {
  description = "Whether to use name_prefix before name or not"
  type        = bool
  default     = false
}

variable "description" {
  type        = string
  description = "Description of security group"
  default     = "Managed by Terraform"
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = set(string)
  default     = []
}

variable "admin_state_up" {
  type        = bool
  description = "The administrative state of the network"
  default     = null
}

########
# Router
########

variable "router" {
  description = "Information used to create and/or connect router to subnets"
  default = {}
}


#########
# Subnets
#########
variable "subnets" {
  description = "List of subnets"
  type        = list(map(string))
  default     = []
}