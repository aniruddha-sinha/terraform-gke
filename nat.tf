// Create an external NAT IP
resource "google_compute_address" "nat" {
  name    = format("%s-nat-ip", var.cluster_name)
  project = var.project_id
  region  = var.region

  depends_on = [
    google_project_service.service,
  ]
}

// Create a cloud router for use by the Cloud NAT
resource "google_compute_router" "router" {
  name    = format("%s-cloud-router", var.cluster_name)
  project = var.project_id
  region  = var.region
  network = google_compute_network.network.self_link

  bgp {
    asn = 64514
  }
}

// Create a NAT router so the nodes can reach DockerHub, etc
resource "google_compute_router_nat" "nat" {
  name    = format("%s-cloud-nat", var.cluster_name)
  project = var.project_id
  router  = google_compute_router.router.name
  region  = var.region

  nat_ip_allocate_option = "MANUAL_ONLY"

  nat_ips = [google_compute_address.nat.self_link]

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.subnetwork.self_link
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]

    secondary_ip_range_names = [
      google_compute_subnetwork.subnetwork.secondary_ip_range.0.range_name,
      google_compute_subnetwork.subnetwork.secondary_ip_range.1.range_name,
    ]
  }

  subnetwork {
    name                    = google_compute_subnetwork.bastion_subnetwork.self_link
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE"]
  }
}

