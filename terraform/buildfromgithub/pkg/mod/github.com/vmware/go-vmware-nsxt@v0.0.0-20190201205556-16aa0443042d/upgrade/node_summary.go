/* Copyright © 2017 VMware, Inc. All Rights Reserved.
   SPDX-License-Identifier: BSD-2-Clause

   Generated by: https://github.com/swagger-api/swagger-codegen.git */

package upgrade

import (
	"github.com/vmware/go-vmware-nsxt/common"
)

type NodeSummary struct {

	// The server will populate this field when returing the resource. Ignored on PUT and POST.
	Links []common.ResourceLink `json:"_links,omitempty"`

	Schema string `json:"_schema,omitempty"`

	Self *common.SelfResourceLink `json:"_self,omitempty"`

	// Component version
	ComponentVersion string `json:"component_version,omitempty"`

	// Number of nodes of the type and at the component version
	NodeCount int32 `json:"node_count,omitempty"`

	// Node type
	Type_ string `json:"type,omitempty"`
}
