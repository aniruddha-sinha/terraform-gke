resource "google_container_node_pool" "private-np-1" {
  provider = google-beta

  name       = "private-np-1"
  location   = var.region
  cluster    = google_container_cluster.cluster.name
  node_count = "2"

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    machine_type = "n1-standard-1"
    disk_type    = "pd-standard"
    disk_size_gb = 30
    image_type   = "COS"


    service_account = google_service_account.gke-sa.email


    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]

    labels = {
      cluster = var.cluster_name
    }

    // Enable workload identity on this node pool
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }

    metadata = {

      google-compute-enable-virtio-rng = "true"

      disable-legacy-endpoints = "true"
    }
  }

  depends_on = [
    google_container_cluster.cluster
  ]
}
