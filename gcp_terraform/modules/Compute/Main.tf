resource "google_compute_instance" "gc_motoru_vm" {
  name         = "gc-motoru-vm"
  machine_type = "e2-micro"
  zone         = var.zone
  tags         = ["iap-ssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
    }
  }

  network_interface {
    subnetwork = var.subnet_id # Modül dışından gelen ağa bağlanıyor
  }

  metadata = {
    description = "Simulated Recommendation Engine - Secure Internal VM"
  }
}