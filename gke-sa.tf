resource "google_service_account" "gke-sa" {
  account_id   = format("%s-node-sa", var.cluster_name)
  display_name = "GKE Security Service Account"
  project      = var.project_id
}

// Add the service account to the project
resource "google_project_iam_member" "service-account" {
  count   = length(var.service_account_iam_roles)
  project = var.project_id
  role    = element(var.service_account_iam_roles, count.index)
  member  = format("serviceAccount:%s", google_service_account.gke-sa.email)
}

// Add user-specified roles
resource "google_project_iam_member" "service-account-custom" {
  count   = length(var.service_account_custom_iam_roles)
  project = var.project_id
  role    = element(var.service_account_custom_iam_roles, count.index)
  member  = format("serviceAccount:%s", google_service_account.gke-sa.email)
}

// Dedicated service account for the Bastion instance
resource "google_service_account" "bastion" {
  account_id   = format("%s-bastion-sa", var.cluster_name)
  display_name = "GKE Bastion SA"
}

//add kubernetes engine admin to bastion node
resource "google_project_iam_member" "service-account-bastion" {
  //count   = length(var.service_account_custom_iam_roles)
  project = var.project_id
  role    = "roles/container.admin"
  member  = format("serviceAccount:%s", google_service_account.bastion.email)
}

resource "google_project_iam_binding" "access_user" {
  role = google_project_iam_custom_role.my_custom_role.id

  members = [
    "user:asinha0493@gmail.com",
    "user:asinha161@gmail.com",
  ]
}

resource "google_project_iam_custom_role" "my_custom_role" {
  role_id = "MyCustomRole"
  title   = "My Custom Role"

  permissions = [
    "compute.projects.get",
    "compute.instances.get",
    "compute.instances.setMetadata",
    "iam.serviceAccounts.actAs",
    "iap.tunnelInstances.accessViaIAP",
  ]
}
