.. _resolved_issues_682:

Resolved Issues in 6.8.2
--------------------------------------------------------------------------------

A complete list of solved issues for 6.8.2 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/73?closed=1>`__.


The following new features have been backported to 6.8.2:

- Virtual Routers now support ``FLOATING_ONLY`` attributes for their network NICs. When this attribute is set to ``yes`` no additional IPs are allocated for the VMs of the VR, :ref:`see more information on the Virtual Router guide <vrouter>`.
- For VMs with resched flag add ``HOST_ID`` to :ref:`External Scheduler API <external_scheduler>`.
- New operation to :ref:`attach/detach PCI passthrough devices in poweroff and undeployed <vm_guide2_pci>`. Note that this feature is available through the API and CLI in this 6.8.2 release.
- Added the Cluster tab to Fireedge Sunstone. See :ref:`the Cluster guide <cluster_guide>` for more information.  To download configuration files, see :ref:`Configuration files <fireedge_files_note>`
- Added the ACL tab to Fireedge Sunstone. See :ref:`the ACL guide <manage_acl>` for more information. To download configuration files, see :ref:`Configuration files <fireedge_files_note>`.

The following issues have been solved in 6.8.2:

- `Fix VM Migration Failure using two SYSTEM_DS on same host <https://github.com/OpenNebula/one/issues/6379>`__.
- `Fix possible segfault in VM disk resize <https://github.com/OpenNebula/one/issues/6432>`__.
- `Fix monitoring encryption <https://github.com/OpenNebula/one/issues/6445>`__.
- `Fix accounting after resizing VM memory or CPU <https://github.com/OpenNebula/one/issues/6387>`__.
- `Fix VMs with serveral SATA disks <https://github.com/OpenNebula/one/issues/5705>`__.
- `Fix DB migration to 6.8.0 fails due to undefined method 'text' <https://github.com/OpenNebula/one/issues/6453>`__.
- `Fix Create VM button is not fully disabled with setting "cloud_vm_create: false" <https://github.com/OpenNebula/one/issues/6450>`__.
- `Fix timeout during oneimage create with higher curl versions <https://github.com/OpenNebula/one/issues/6431>`__.
- `Fix occasional duplicate floating IP in HA environment, which cause monitroing issues <https://github.com/OpenNebula/one/issues/6372>`__.
- `Fix oneflow client adding uri prefix path to the http request path <https://github.com/OpenNebula/one/issues/5768>`__.
- `Fix PCI passthrough device addresses for machine models based on q35 <https://github.com/OpenNebula/one/issues/6372>`__.

Also, the following issues have been solved in the FireEdge Sunstone Web UI:

- `Fix cannot upload image" issue <https://github.com/OpenNebula/one/issues/6423>`__.
- `Fix validation checkbox <https://github.com/OpenNebula/one/issues/6418>`__.
- `Fix multiple issues with image pool view <https://github.com/OpenNebula/one/issues/6380>`__.
- `Fix User Input list sorting error <https://github.com/OpenNebula/one/issues/6229>`__.
- `Fix poweroff hard available for SHUTDOWN state <https://github.com/OpenNebula/one/issues/6448>`__.
- `New Virtual Network Template Tab <https://github.com/OpenNebula/one/issues/6118>`__.
- `Add generic template to Settings for User template <https://github.com/OpenNebula/one/issues/6219>`__.
