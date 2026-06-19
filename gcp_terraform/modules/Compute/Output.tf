output "vm_name" {
  value = google_compute_instance.gc_motoru_vm.name
}

output "vm_internal_ip" {
  value = google_compute_instance.gc_motoru_vm.network_interface[0].network_ip
}