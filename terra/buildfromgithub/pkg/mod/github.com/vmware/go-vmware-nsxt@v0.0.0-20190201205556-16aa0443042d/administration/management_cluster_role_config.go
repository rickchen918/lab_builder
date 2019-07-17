/* Copyright © 2017 VMware, Inc. All Rights Reserved.
   SPDX-License-Identifier: BSD-2-Clause

   Generated by: https://github.com/swagger-api/swagger-codegen.git */

package administration

import (
	"github.com/vmware/go-vmware-nsxt/manager"
)

type ManagementClusterRoleConfig struct {

	// Type of this role configuration
	Type_ string `json:"type,omitempty"`

	// The IP and port for the public API service on this node
	ApiListenAddr *ServiceEndpoint `json:"api_listen_addr,omitempty"`

	// The IP and port for the management cluster service on this node
	MgmtClusterListenAddr *ServiceEndpoint `json:"mgmt_cluster_listen_addr,omitempty"`

	// The IP and port for the management plane service on this node
	MgmtPlaneListenAddr *ServiceEndpoint `json:"mgmt_plane_listen_addr,omitempty"`

	MpaMsgClientInfo *manager.MsgClientInfo `json:"mpa_msg_client_info,omitempty"`
}
