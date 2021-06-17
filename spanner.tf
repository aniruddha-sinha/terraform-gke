resource "google_spanner_instance" "spanner_inst" {
  config       = var.spanner_config
  display_name = "spanner-poc"
  num_nodes    = var.num_spanner_nodes
  force_destroy = true
  #   labels = {
  #     "foo" = "bar"
  #   }
}