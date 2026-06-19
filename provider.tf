terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

# AWS Sağlayıcısı
provider "aws" {
  region = var.aws_region
}

# GCP Sağlayıcısı
provider "google" {
  project     = "project-347d1b09-e634-4990-a4c"
  region      = var.gcp_region
  credentials = file("./gcp-key.json")
}