// Allow access to the Bastion Host via SSH
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

// The user-data script on Bastion instance provisioning
data "template_file" "startup_script" {
  template = <<-EOF
  sudo apt-get update -y
  sudo apt-get install -y tinyproxy
  EOF

}

// The Bastion Host
resource "google_compute_instance" "bastion" {
  count        = length(var.bastion_zones)
  name         = "bastion-jump0${count.index}"
  machine_type = "n1-standard-1"
  zone         = var.bastion_zones[count.index] //var.zone
  project      = var.project_id
  tags         = ["bastion"]

  // Specify the Operating System Family and version.
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  // Ensure that when the bastion host is booted, it will have tinyproxy
  metadata_startup_script = data.template_file.startup_script.rendered

  // Define a network interface in the correct subnet.
  network_interface {
    subnetwork = google_compute_subnetwork.bastion_subnetwork.name

    // Add an ephemeral external IP.
    # access_config {
    #   // Ephemeral IP
    # }
  }

  // Allow the instance to be stopped by terraform when updating configuration
  allow_stopping_for_update = true

  service_account {
    email  = google_service_account.bastion.email
    scopes = ["cloud-platform"]
  }
}
