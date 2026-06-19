# --- AWS DEĞİŞKENLERİ ---
variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.2.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.2.1.0/24", "10.2.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.2.10.0/24", "10.2.20.0/24"]
}

# --- GCP DEĞİŞKENLERİ ---
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