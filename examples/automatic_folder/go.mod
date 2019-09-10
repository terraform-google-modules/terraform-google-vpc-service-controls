module function

require github.com/otiai10/copy v1.0.1

replace git.apache.org/thrift.git => github.com/apache/thrift v0.0.0-20180902110319-2566ecd5d999

require (
	github.com/hashicorp/terraform v0.12.8
	github.com/otiai10/curr v0.0.0-20190513014714-f5a3d24e5776 // indirect
)

go 1.13
