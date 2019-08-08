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
}

data "nsxt_logical_tier1_router" "tier1_router" {
  display_name = "terraform_t1_0"
}


