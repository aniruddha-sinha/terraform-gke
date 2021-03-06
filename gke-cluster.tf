resource "google_container_cluster" "cluster" {
  provider = google-beta
  name     = var.cluster_name
  project  = var.project_id
  location = var.region

  network    = google_compute_network.network.self_link
  subnetwork = google_compute_subnetwork.subnetwork.self_link

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"


  remove_default_node_pool = "true"
  initial_node_count       = 1

  // Configure various addons
  addons_config {
    network_policy_config {
      disabled = false
    }
  }

  // Enable workload identity
  workload_identity_config {
    identity_namespace = format("%s.svc.id.goog", var.project_id)
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = "false"
    }
  }

  // Enable network policy configurations (like Calico) - for some reason this
  // has to be in here twice.
  network_policy {
    enabled = "true"
  }

  // Allocate IPs in our subnetwork
  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.subnetwork.secondary_ip_range.0.range_name
    services_secondary_range_name = google_compute_subnetwork.subnetwork.secondary_ip_range.1.range_name
  }

  // Specify the list of CIDRs which can access the master's API
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.zonal_node_locations
      content {
        display_name = "bastion-${cidr_blocks.key}"
        cidr_block   = format("%s/32", google_compute_instance.bastion["${cidr_blocks.key}"].network_interface.0.network_ip)
      }
    }
  }
  // Configure the cluster to have private nodes and private control plane access only
  private_cluster_config {
    enable_private_endpoint = "true"
    enable_private_nodes    = "true"
    master_ipv4_cidr_block  = "172.16.0.16/28"
  }

  // Allow plenty of time for each operation to finish (default was 10m)
  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  depends_on = [
    google_project_service.service,
    google_project_iam_member.service-account,
    google_project_iam_member.service-account-custom,
    google_compute_router_nat.nat,
    google_compute_instance.bastion
  ]

}
