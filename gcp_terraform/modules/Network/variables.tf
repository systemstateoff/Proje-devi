variable "gcp_region" {
  type    = string
  default = "us-central1"
}

variable "subnet_cidr" {
  type    = string
  default = "10.3.0.0/24"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "subnet_id" {
  type    = string
  default = "" # Network modülü oluştururken bu boş kalabilir
}
