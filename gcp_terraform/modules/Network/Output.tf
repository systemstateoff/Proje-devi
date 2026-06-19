output "subnet_id" {
  value = google_compute_subnetwork.gcp_subnet.id
}

output "vpc_name" {
  value = google_compute_network.custom_vpc.name
}