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

variable "ssh_pub_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "ssh_keys/id_rsa.pub"
}