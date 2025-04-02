.. _whats_new:

================================================================================
What’s New in |version|
================================================================================

OpenNebula Core
================================================================================

- The ability to import wild VMs into OpenNebula has been removed from code to provide a more coherent management experience across all interfaces and APIs.
- The enforce parameter has been restored for the resize operation. In this context, it only manages capacity enforcement checks (memory and CPU), while the NUMA topology is always verified independently.
- Option to define :ref:`Compute Quotas per Cluster <compute_quotas>` to achieve more granular control of resources.

Storage & Backups
================================================================================

- :ref:`Integrated NFS life-cycle setup <automatic_nfs_setup>` for volumes in shared datastore.

FireEdge Sunstone
================================================================================

- Removed Provision/Provider as application :ref:`FireEdge Sunstone <fireedge_sunstone>`.
- Architectural shift to Micro-Frontend as part of the Dynamic Tabs update :ref:`Sunstone development guide <sunstone_dev>`.
- Guacamole VDI over SSH tunnel :ref:`Remote connections guide <fireedge_remote_connections>`.

API and CLI
================================================================================

- `The 'onedb purge-history' command now removes history records only within the specified --start, --end range for the --id, instead of deleting all records <https://github.com/OpenNebula/one/issues/6699>`__.
- Feature 2

KVM
================================================================================

- Feature 1
- Feature 2


OpenNebula Gate
================================================================================


OpenNebula Flow
================================================================================

- `Oneflow clients include content-type header to make them work with Sinatra 4.0.0 <https://github.com/OpenNebula/one/issues/6508>__`.


Features Backported to 6.10.x
================================================================================

Additionally, the following functionalities are present that were not in OpenNebula 6.10.0, although they debuted in subsequent maintenance releases of the 6.10.x series:

- `Fix de-selecting hidden datatable entries <https://github.com/OpenNebula/one/issues/6781>`__.
- `Text of selection in schedule action <https://github.com/OpenNebula/one/issues/6410>`__.
- `Fix Filter datastore type when deploy a VM <https://github.com/OpenNebula/one/issues/6927>`__.
- `Fix show more labels in cards <https://github.com/OpenNebula/one/issues/6643>`__.
- `Fix host tab does not validate Enable/Disable button states <https://github.com/OpenNebula/one/issues/6792>`__.
- `Fix add qcow2 format support for volatile disk type "swap" <https://github.com/OpenNebula/one/issues/6622>`__.

Other Issues Solved
================================================================================

- `Limit password size for each authentication driver to prevent DoS attacks <https://github.com/OpenNebula/one/issues/6892>`__.
- `For 'list' and 'top' commadns fix filter flag G exposing resources of other group members <https://github.com/OpenNebula/one/issues/6952>`__.
