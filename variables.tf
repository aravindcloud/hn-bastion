variable "prefix" {
  description = "This prefix will be included in the name of some resources."
  default     = "hn"
}

variable "resource_group" {
  description = "The name of your Azure Resource Group."
  default     = "health-now-rg"
}
variable "location" {
  description = "The region where the virtual network is created."
  default     = "centralus"
}
variable "virtual_network_name" {
  description = "The name for your virtual network."
  default     = "hn-vnet"
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "20.0.0.0/16"
}

variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "20.0.1.0/24"
}

variable "vm_size" {
  description    = "Virtual Machine Compute Size"
  default = "Standard_DS2_v2"
}

variable "admin_username" {
  description = "Administrator user name"
  default     = "hnserviceadmin"
}

variable "admin_password" {
  description = "Administrator password"
  default     = "GQTeTnPYFM9vpcQ7"
}

variable "source_network" {
  description = "Allow access from this network prefix. Defaults to '*'."
  default     = "*"
}

variable "vm_count" {
  default  = 1
}

variable "vm_image_string" {
  default = "MicrosoftWindowsServer/WindowsServer/2012-Datacenter/latest"
}

variable "tag" {
  default = "dev"
}