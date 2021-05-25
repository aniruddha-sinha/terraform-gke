resource "google_project_service" "service" {
  count              = length(var.project_services)
  project            = var.project_id
  service            = element(var.project_services, count.index)
  disable_on_destroy = false
}
