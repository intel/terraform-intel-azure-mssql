

input.availability_zone (required)
Availability zone to use. Should be set to VMs AZ.

input.device_path (required)
Device name to mount at. Refer to AWS "Device names on Windows instances" and "Device names on Linux instances" guides to understand allowed device names.

input.module_cloud_env (required)
Takes Cloud-env object.

input.size (required)
Size of created disk.

input.storagetype (required)
Type of storage to use.

input.tags (required)
Tags which to attach to disk.

input.vm_id (required)
ID of VM object to which disks should be attached.

input.vm_name (required)
Name of VM object to which disks should be attached.

input.iops (null)
IOPS parameter of created disk (only supported on some disk types). If omitted, uses default.

input.throughput (null)
Throughput parameter of created disk (only supported on some disk types). If omitted, uses default.
