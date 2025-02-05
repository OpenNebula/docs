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

- Feature 1
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

- Feature 1
- Feature 2

Other Issues Solved
================================================================================

- Issue 1
- Issue 2
