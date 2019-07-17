/* Copyright © 2017 VMware, Inc. All Rights Reserved.
   SPDX-License-Identifier: BSD-2-Clause

   Generated by: https://github.com/swagger-api/swagger-codegen.git */

package administration

type CreateRemoteDirectoryProperties struct {

	// Server port
	Port int64 `json:"port,omitempty"`

	// Remote server hostname or IP address
	Server string `json:"server"`

	// URI of file to copy
	Uri string `json:"uri"`
}
