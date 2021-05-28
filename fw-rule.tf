// Allow access to the Bastion Host via SSH IAP
resource "google_compute_firewall" "bastion-ssh" {
  name          = format("%s-bastion-ssh", var.cluster_name)
  network       = google_compute_network.network.name
  direction     = "INGRESS"
  project       = var.project_id
  source_ranges = ["35.235.240.0/20"]


  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
  target_tags = ["bastion"]
}
