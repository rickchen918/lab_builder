/* Copyright © 2017 VMware, Inc. All Rights Reserved.
   SPDX-License-Identifier: BSD-2-Clause

   Generated by: https://github.com/swagger-api/swagger-codegen.git */

package manager

// Node network interface alias
type NodeInterfaceAlias struct {

	// Interface broadcast address
	BroadcastAddress string `json:"broadcast_address,omitempty"`

	// Interface IP address
	IpAddress string `json:"ip_address,omitempty"`

	// Interface configuration
	IpConfiguration string `json:"ip_configuration,omitempty"`

	// Interface netmask
	Netmask string `json:"netmask,omitempty"`

	// Interface MAC address
	PhysicalAddress string `json:"physical_address,omitempty"`
}
