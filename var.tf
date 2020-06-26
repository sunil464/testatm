variable "resource_group_name" {
  default = "gx-terraform-poc"
}

variable "location" {
  default = "West US 2"
}

variable "prefix" {
  default = "gx-"
}


variable "traffic_manager_name" {
  default = "gx-poc"
}


variable "atm_ep1" {
  default = "mk1.eastus.cloudapp.azure.com"
}

variable "atm_ep2" {
  default = "mk2.eastus.cloudapp.azure.com"
}
