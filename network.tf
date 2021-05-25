// Create a network for GKE
resource "google_compute_network" "network" {
  name                    = format("%s-network", var.cluster_name)
  project                 = var.project_id
  auto_create_subnetworks = false

  depends_on = [
    google_project_service.service,
  ]
}

// Create subnets
resource "google_compute_subnetwork" "subnetwork" {
  name          = format("%s-subnet", var.cluster_name)
  project       = var.project_id
  network       = google_compute_network.network.self_link
  region        = var.region
  ip_cidr_range = var.ip_cidr_range

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = format("%s-pod-range", var.cluster_name)
    ip_cidr_range = var.secondary_ip_range_one
  }

  secondary_ip_range {
    range_name    = format("%s-svc-range", var.cluster_name)
    ip_cidr_range = var.secondary_ip_range_two
  }
}

resource "google_compute_subnetwork" "bastion_subnetwork" {
  name          = format("%s-bastion-subnet", var.cluster_name)
  project       = var.project_id
  network       = google_compute_network.network.self_link
  region        = var.region
  ip_cidr_range = var.bastion_ip_cidr_range

  private_ip_google_access = true

  # secondary_ip_range {
  #   range_name    = format("%s-pod-range", var.cluster_name)
  #   ip_cidr_range = var.secondary_ip_range_one
  # }

  # secondary_ip_range {
  #   range_name    = format("%s-svc-range", var.cluster_name)
  #   ip_cidr_range = var.secondary_ip_range_two
  # }
}
