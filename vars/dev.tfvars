project_id = "vector-charlie"
region     = "us-central1"

#network params
bastion_ip_cidr_range  = "10.0.1.0/28"
ip_cidr_range          = "10.0.0.0/24"
secondary_ip_range_one = "10.1.0.0/16"
secondary_ip_range_two = "10.2.0.0/20"

#cluster basic
cluster_name = "pvt-gke"
###zonal node pool locations
zonal_node_locations = ["us-central1-a", "us-central1-f"]

#bastion node config
bastion_node_machine_type = "n1-standard-1"
bastion_zones             = ["us-central1-c", "us-central1-b", "us-central1-f"]

#node config
node_machine_type    = "n1-standard-1"
node_disk_type       = "pd-standard"
node_disk_size_in_gb = 30