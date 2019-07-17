/* Copyright © 2017 VMware, Inc. All Rights Reserved.
   SPDX-License-Identifier: BSD-2-Clause

   Generated by: https://github.com/swagger-api/swagger-codegen.git */

package manager

// Tunnel information between two given transport nodes
type PortConnectionTunnel struct {

	// Id of the source transport node
	SrcNodeId string `json:"src_node_id"`

	// Tunnel properties between the source and the destination transport node
	TunnelProperties *TunnelProperties `json:"tunnel_properties"`
}
