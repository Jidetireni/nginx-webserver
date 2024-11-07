variable "key" {
  description = "key"
  type = string
}

variable "project" {
  description = "project id"
  type = string

}

variable "region" {
  description = "project region"
  type = string
}

variable "zone" {
  description = "project zone"
  type = string
}

variable "instance_name" {
  description = "instance name"
  type = string
}

variable "machine_type" {
  description = "machine type"
  type = string
}

variable "boot_disk_size" {
  description = "Boot disk size in gb"
  type = number
}

variable "labels" {
  description = "VM instance label"
  type = map(string)
}

variable "static_ip_name" {
  description = "static ip name"
  type = string
}