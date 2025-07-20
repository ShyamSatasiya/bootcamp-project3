variable "location" {
  description = "Azure region to deploy into"
  type        = string
}

variable "vm_count" {
  description = "How many VMs to create"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "VM SKU/size"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_user" {
  description = "Username for the Linux VM admin account"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Password for the Linux VM admin user (must meet Azure’s complexity requirements)"
  type        = string
  sensitive   = true
}
