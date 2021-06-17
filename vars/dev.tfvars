project_id = "zulu-six-four"
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
bastion_node_machine_type = "f1-micro"
#as of now you need two linux bastion zones; figuring out how to make it to accept minimum of 1 zone
bastion_zones = ["us-central1-c", "us-central1-f"] //, "us-central1-f"

#node config
node_machine_type    = "e2-medium"
node_disk_type       = "pd-standard"
node_disk_size_in_gb = 70

#spanner config
#picks up regional or multi-region automatically
#example for region just enter "regional-us-central1"
#for multi-region enter "nam-eur-asia1"
spanner_config = "regional-us-central1"

num_spanner_nodes = 1