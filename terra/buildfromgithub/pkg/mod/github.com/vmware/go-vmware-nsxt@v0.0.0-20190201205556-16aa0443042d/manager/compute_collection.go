/* Copyright © 2017 VMware, Inc. All Rights Reserved.
   SPDX-License-Identifier: BSD-2-Clause

   Generated by: https://github.com/swagger-api/swagger-codegen.git */

package manager

import (
	"github.com/vmware/go-vmware-nsxt/common"
)

type ComputeCollection struct {

	// The server will populate this field when returing the resource. Ignored on PUT and POST.
	Links []common.ResourceLink `json:"_links,omitempty"`

	Schema string `json:"_schema,omitempty"`

	Self *common.SelfResourceLink `json:"_self,omitempty"`

	// Timestamp of last modification
	LastSyncTime int64 `json:"_last_sync_time,omitempty"`

	// Description of this resource
	Description string `json:"description,omitempty"`

	// Defaults to ID if not set
	DisplayName string `json:"display_name,omitempty"`

	// The type of this resource.
	ResourceType string `json:"resource_type,omitempty"`

	// Opaque identifiers meaningful to the API user
	Tags []common.Tag `json:"tags,omitempty"`

	// Local Id of the compute collection in the Compute Manager
	CmLocalId string `json:"cm_local_id,omitempty"`

	// External ID of the ComputeCollection in the source Compute manager, e.g. mo-ref in VC
	ExternalId string `json:"external_id,omitempty"`

	// Id of the compute manager from where this Compute Collection was discovered
	OriginId string `json:"origin_id,omitempty"`

	// Key-Value map of additional specific properties of compute collection in the Compute Manager
	OriginProperties []common.KeyValuePair `json:"origin_properties,omitempty"`

	// ComputeCollection type like VC_Cluster. Here the Compute Manager type prefix would help in differentiating similar named Compute Collection types from different Compute Managers
	OriginType string `json:"origin_type,omitempty"`
}
