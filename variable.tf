variable "project_id" {
  description = "The project in which to hold the components"
  type        = string
}

variable "region" {
  description = "The region in which to create the VPC network"
  type        = string
}

variable "zone" {
  description = "The zone in which to create the Kubernetes cluster. Must match the region"
  type        = string
}

variable "cluster_name" {
  description = "The name to give the new Kubernetes cluster."
  type        = string
}

variable "ip_cidr_range" {
  description = "the ip cidr range for subnetwork"
  type        = string
}

variable "bastion_ip_cidr_range" {
  description = "the ip cidr range where the bastion instance will be residing"
  type        = string
}

variable "bastion_zones" {
  type = list(string)
}

variable "secondary_ip_range_one" {
  type = string
}

variable "secondary_ip_range_two" {
  type = string
}

variable "service_account_iam_roles" {
  type = list(string)

  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
  ]
  description = <<-EOF
  List of the default IAM roles to attach to the service account on the
  GKE Nodes.
  EOF
}

variable "service_account_custom_iam_roles" {
  type    = list(string)
  default = []

  description = <<-EOF
  List of arbitrary additional IAM roles to attach to the service account on
  the GKE nodes.
  EOF
}

variable "project_services" {
  type = list(string)

  default = [
    "cloudresourcemanager.googleapis.com",
    "servicenetworking.googleapis.com",
    "container.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "sqladmin.googleapis.com",
    "securetoken.googleapis.com",
    "iap.googleapis.com",
    "cloudkms.googleapis.com"
  ]
  description = <<-EOF
  The GCP APIs that should be enabled in this project.
  EOF
}
