provider "vsphere" {
  user = "administrator@rkc.local"
  password = "Nicira123$"
  vsphere_server = "vc.rkc.local"
  allow_unverified_ssl = true 
}

data "vsphere_datacenter" "dc" {
  name = "Home"
}

data "vsphere_datastore" "datastore" {
  name = "ssd_lab"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster1" {
  name = "cluster67"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network1" {
  name = "Trunk"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

/* refer this vm template to clone vm */
data "vsphere_virtual_machine" "template" {
  name = "win10_template"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm1" {
  count = 1
  name = "win10_${count.index}"
  resource_pool_id= "${data.vsphere_compute_cluster.cluster1.resource_pool_id}"
  datastore_id = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 4
  nested_hv_enabled = true
  memory = 16384
  guest_id = "windows9_64Guest"
  wait_for_guest_net_timeout = 0

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "disk0"
    size = 120
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    linked_clone = "true"
  }

}
