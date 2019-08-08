provider "vsphere" {
  user = "administrator@rkc.local"
  password = "Nicira123$"
  vsphere_server = "iotvc.rkc.local"
  allow_unverified_ssl = true 
}

data "vsphere_datacenter" "dc" {
  name = "flash_dc"
}

data "vsphere_datastore" "datastore" {
  name = "ssd_lab"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster1" {
  name = "flash_compute"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network0" {
  name = "terraform_ls_0"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network1" {
  name = "terraform_ls_1"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network2" {
  name = "terraform_ls_2"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network3" {
  name = "terraform_ls_3"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network4" {
  name = "terraform_ls_4"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

/* refer this vm template to clone vm */
data "vsphere_virtual_machine" "template" {
  name = "vm_temp"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm0" {
  count = 2
  name = "terra0-vm1${count.index}"
  resource_pool_id= "${data.vsphere_compute_cluster.cluster1.resource_pool_id}"
  datastore_id = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory = 2048
  guest_id = "ubuntu64Guest"
  wait_for_guest_net_timeout = 0
/*  nested_hv_enabled = true */

  network_interface {
    network_id = "${data.vsphere_network.network0.id}"
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

resource "vsphere_virtual_machine" "vm1" {
  count = 2
  name = "terra1-vm1${count.index}"
  resource_pool_id= "${data.vsphere_compute_cluster.cluster1.resource_pool_id}"
  datastore_id = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory = 2048
  guest_id = "ubuntu64Guest"
  wait_for_guest_net_timeout = 0
/*  nested_hv_enabled = true */

  network_interface {
    network_id = "${data.vsphere_network.network1.id}"
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

resource "vsphere_virtual_machine" "vm2" {
  count = 2
  name = "terra2-vm1${count.index}"
  resource_pool_id= "${data.vsphere_compute_cluster.cluster1.resource_pool_id}"
  datastore_id = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory = 2048
  guest_id = "ubuntu64Guest"
  wait_for_guest_net_timeout = 0
/*  nested_hv_enabled = true */

  network_interface {
    network_id = "${data.vsphere_network.network2.id}"
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

resource "vsphere_virtual_machine" "vm3" {
  count = 2
  name = "terra3-vm1${count.index}"
  resource_pool_id= "${data.vsphere_compute_cluster.cluster1.resource_pool_id}"
  datastore_id = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory = 2048
  guest_id = "ubuntu64Guest"
  wait_for_guest_net_timeout = 0
/*  nested_hv_enabled = true */

  network_interface {
    network_id = "${data.vsphere_network.network3.id}"
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

resource "vsphere_virtual_machine" "vm4" {
  count = 2
  name = "terra4-vm1${count.index}"
  resource_pool_id= "${data.vsphere_compute_cluster.cluster1.resource_pool_id}"
  datastore_id = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory = 2048
  guest_id = "ubuntu64Guest"
  wait_for_guest_net_timeout = 0
/*  nested_hv_enabled = true */

  network_interface {
    network_id = "${data.vsphere_network.network4.id}"
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
