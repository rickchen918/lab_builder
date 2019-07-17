/* Copyright © 2017 VMware, Inc. All Rights Reserved.
   SPDX-License-Identifier: BSD-2-Clause

   Generated by: https://github.com/swagger-api/swagger-codegen.git */

package administration

type SupportBundleRequest struct {

	// Bundle should include content of specified type
	ContentFilters []string `json:"content_filters,omitempty"`

	// Include log files with modified times not past the age limit in days
	LogAgeLimit int64 `json:"log_age_limit,omitempty"`

	// List of cluster/fabric node UUIDs processed in specified order
	Nodes []string `json:"nodes"`

	// Remote file server to copy bundles to, bundle in response body if not specified
	RemoteFileServer *SupportBundleRemoteFileServer `json:"remote_file_server,omitempty"`
}
