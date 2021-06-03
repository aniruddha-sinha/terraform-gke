## Private GKE Cluster

>This solution comprises of end to end infrastructure deployment of GKE Cluster. 

**This solution creates the following resources in GKE** (_mentioned in the order of creation_):
* VPC
* Subnetwork 
  * One subnetwork exclusively for GKE (node pools)
  * One subnetwork for the Linux Bastion
* Cloud NAT
* Service accounts for IAP and Linux Bastion
* Linux Bastion with Cloud IAP enabled for SSH Tunneling
* GKE regional Cluster
* GKE node pool with choice for creating nodes in specified zones in the region
