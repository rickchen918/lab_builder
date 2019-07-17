variable "nsx_manager" {}
variable "nsx_username" {}
variable "nsx_password" {}
variable "t0_name" {}
variable "tz" {}
variable "edgecluster" {}
variable "count" {}
#variable count "{count=3}

provider "nsxt" {
  host = "${var.nsx_manager}"
  username = "${var.nsx_username}"
  password = "${var.nsx_password}"
  allow_unverified_ssl = true
  max_retries = 2
}

data "nsxt_transport_zone" "overlay_tz" {
  display_name = "${var.tz}"
}

data "nsxt_logical_tier0_router" "k8s-t0" {
  display_name = "k8s-t0"
}

data "nsxt_edge_cluster" "k8s_edgecluster" {
  display_name = "k8s_edgecluster"
}

data "nsxt_logical_tier1_router_test" "k8s-t1" {
  display_name = "k8s-t1"
}
