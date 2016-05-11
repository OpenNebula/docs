.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 4.14.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`section <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 5.0.

Deprecated Components
================================================================================

The **Xen** hypervisor is no longer included in the main distribution. It can be however manually installed through the `Xen Add-on <https://github.com/OpenNebula/addon-xen>`__.

The **VMware** hypervisor is no longer included in the main distribution. Users are encourage to migrate to the more robust and enterprise-ready :ref:`VMware vCenter Drivers <vcenterg>`.

The **SoftLayer** Hybrid driver is no longer included in the main distribution. It can be however manually installed through the `SoftLayer Add-on <https://github.com/OpenNebula/addon-softlayer>`__.


OpenNebula Administrators and Users
================================================================================

OpenNebula Daemon
--------------------------------------------------------------------------------

The logging facilities have been updated to get rid of the log4cpp dependencies.
Although the format of the messages has been preserved you may need to double
check any tool parsing directly syslog messages. Also a new log facility has been
included (std) that uses the stderr stream. Follow this link to the :ref:`Log and Debug section <log_debug>` for more information.

Virtual Machine Management
--------------------------------------------------------------------------------

Virtual Machines in RUNNING state can now take disk snapshots if the drivers support it (kvm with ceph or qcow2), otherwise the VM needs to be manually powered off or suspended. Similarly, the disk snapshot revert operation requires the VM to be powered off or suspended. The strategy option has been removed from the VMM drivers, as well as the DISK_SNAPSHOT_REVERT state (for VMs doing a snapshot operation while RUNNING).

VNC port assignment has been improved in 5.0 to support TCP port reservations and to better reuse the port pool. The VNC port is checked now at the cluster level and not zone-wise, so a VM can be deployed/migrated in/to any host in the selected cluster. The automatic port selection assignment will first try ``VNC_PORTS[START] + VMID`` as in previous versions. Moreover, in this new version if the user sets a port its availability is first checked. ``VNC_BASE_PORT`` attribute in ``oned.conf`` has been changed to ``VNC_PORTS`` to include also a set of reserved ports. See :ref:`the oned.conf reference <oned_conf>` for more information.

Context is now generated whenever a VirtualMachine is started in a host, i.e. when the deploy or restore action is invoked or when a NIC is attached/detached from the VM. This means that a new attached NIC will have the IP properly configured.

.. todo:: `Feature #3932 <http://dev.opennebula.org/issues/3932>`_ Rename shutdown action to terminate

.. todo:: `Feature #4400 <http://dev.opennebula.org/issues/4400>`_ instantiate to persistent

.. todo:: boot order (new syntax), and boot order update

.. todo:: `Feature #4157 <http://dev.opennebula.org/issues/4157>`_ Add support for qemu guest agent

Scheduler
--------------------------------------------------------------------------------

The scheduler now considers secondary groups to schedule VMs for both hosts and
datastores (see ``feature #4156 <http://dev.opennebula.org/issues/4156>`_ <http://dev.opennebula.org/issues/4156>`__). This
feature enable users to effectively use multiple VDCs. This may **only** affect
to installations using multiple groups per user.

Clusters
--------------------------------------------------------------------------------

In 5.0 we have introduced to possibility to add Datastores and VNets to more than one cluster. At the same time, we have eliminated the 'none' (-1) cluster.

In OpenNebula 4.14 this special cluster none was used to share Datastores and VNets across all clusters. In 5.0 the resources outside of any cluster are "disabled for new deployments" from the scheduler's point of view. You will need to explicitly add your resources to all the clusters that are configured to use those Datastores and VNets.

Hosts
--------------------------------------------------------------------------------

.. todo:: `Feature #4403 <http://dev.opennebula.org/issues/4403>`_ new OFFLINE state

Storage and Datastores
--------------------------------------------------------------------------------

**BASE_PATH has been deprecated**

The attribute ``BASE_PATH`` has been deprecated and removed from the interface. If it was defined in the Datastore templates, it has now been removed. This means, that everything is now built on ``DATASTORE_LOCATION`` as defined in ``oned.conf``, which defaults to ``/var/lib/one/datastores``. If you were using a different ``BASE_PATH``, you will need to create a symbolic link in your nodes to fix that mountpoint. Something along the lines of: ``ln -s <BASE_PATH> /var/lib/one/datastores``.

**FSTYPE has been deprecated**

Datablocks and Volatile Disks can now only be ``raw`` or ``qcow2`` (and ``swap`` for volatile disks). They will be created as blocks and no filesystem will be created inside. The options like ``ext3, ext4, vfat, etc`` are not supported any more. Furthermore, the attribute ``FSTYPE`` has been deprecated. The logic is the following:

- New Empty Datablock:

  - ``if DRIVER == qcow2`` => The block will be created as ``qcow2``.
  - ``if DRIVER != qcow2`` => The block will be created as ``raw``.
  - ``if DRIVER is empty && TM_MAD == qcow2`` => The block will be created as ``qcow2``.
  - ``if DRIVER is empty && TM_MAD != qcow2`` => The block will be created as ``raw``.

- Volatile Disk:

  - Same logic as above, except if ``TYPE == swap``.
  - ``if TYPE == swap`` => The block will be created as ``raw`` and formatted as ``swap`` (regardless if the ``TM_MAD == qcow2``).

.. todo:: `Feature #3987 <http://dev.opennebula.org/issues/3987>`_ Make Ceph a system datastore capable driver

.. todo:: `Feature #3915 <http://dev.opennebula.org/issues/3915>`_ deprecate SOURCE = http

.. todo:: `Feature #3907 <http://dev.opennebula.org/issues/3907>`_ Rethink the Image datablock qcow2 options

Disk Templates
--------------------------------------------------------------------------------

Any attribute defined explicitly in the ``DISK`` section of a Template or of a Virtual Machine template, will **not** be overwritten by the same attribute defined in the Image template or in the Datastore template, even if the attribute is marked as ``INHERIT`` in ``oned.conf``. The precedence of the attributes is evaluated in this order (most important to least important):

- ``DISK`` section of the Template
- Image template
- Datastore template

Virtual Networks
--------------------------------------------------------------------------------

Before OpenNebula 5.0, when doing reservations of Virtual Networks with VLAN isolation, but without the VLAN_ID parameter, the VLAN_ID of the reservation and the parent network where not in the same space; meaning that they were isolated from one another. This behavior has been fixed in OpenNebula >= 5.0: the reservation will inherit the same VLAN_ID as the parent. Note that this will affect only newly created Virtual Machines, the old ones will exhibit the old behavior.

The old ``fw`` driver has been removed from OpenNebula (it was deprecated in OpenNebula 4.12). If you are still using it, we recommended that you remove those VMs. After the upgrade to 5.0, OpenNebula will not create/modify/remove any of the iptables rules related to the ``fw`` driver. The database migration utility ``onedb`` will detect if you still have any VMs using this functionality. In any case, please switch to :ref:`Security Groups <security_groups>` which deliver more functionality than the old ``fw`` driver.

The Security Group update action now automatically triggers the :ref:`update of the rules for all the VMs in the security group <security_groups_update>`. This operation can be also manually triggered at any time with the ``onesecgroup commit`` command.

.. todo:: `Feature #3848 <http://dev.opennebula.org/issues/3848>`_ Virtual networks should have an associated networking driver

.. todo:: `Feature #3707 <http://dev.opennebula.org/issues/3707>`_ re-evalute the VLAN attribute

Sunstone
--------------------------------------------------------------------------------

.. todo:: `Feature #4317 <http://dev.opennebula.org/issues/4317>`_ Redesign group admin view. Instance types, groupadmin based on admin, user inputs for capacity.

Developers and Integrators
================================================================================

Transfer Manager
--------------------------------------------------------------------------------

.. todo:: New monitor script for system datastores

Virtual Machine Manager
--------------------------------------------------------------------------------

Context is now generated whenever a VirtualMachine is started in a host, i.e. when the deploy or restore action is invoked or when a NIC is attached/detached from the VM. Driver integrators may want to implement the :ref:`reconfigure VMM driver action <devel-vmm>`. This new action notifies a running VM that the context has changed and needs to reconfigure its NICs.

Sunstone
--------------------------------------------------------------------------------

All the SUNSTONE specific information in VM Template, Group, User and other object templates has been arranged in a vector attribute like:

* USER

+----------------------------------------+-------------------------------------------------+
|   ``TEMPLATE/SUNSTONE_DISPLAY_NAME``   |        ``TEMPLATE/SUNSTONE/DISPLAY_NAME``       |
+----------------------------------------+-------------------------------------------------+
| ``TEMPLATE/LANG``                      | ``TEMPLATE/SUNSTONE/LANG``                      |
+----------------------------------------+-------------------------------------------------+
| ``TEMPLATE/TABLE_DEFAULT_PAGE_LENGTH`` | ``TEMPLATE/SUNSTONE/TABLE_DEFAULT_PAGE_LENGTH`` |
+----------------------------------------+-------------------------------------------------+
| ``TEMPLATE/TABLE_ORDER``               | ``TEMPLATE/SUNSTONE/TABLE_ORDER``               |
+----------------------------------------+-------------------------------------------------+
| ``TEMPLATE/DEFAULT_VIEW``              | ``TEMPLATE/SUNSTONE/DEFAULT_VIEW``              |
+----------------------------------------+-------------------------------------------------+
| ``TEMPLATE/GROUP_ADMIN_DEFAULT_VIEW``  | ``TEMPLATE/SUNSTONE/GROUP_ADMIN_DEFAULT_VIEW``  |
+----------------------------------------+-------------------------------------------------+

* GROUP

+---------------------------------------+------------------------------------------------+
|      ``TEMPLATE/SUNSTONE_VIEWS``      |          ``TEMPLATE/SUNSTONE/VIEWS``           |
+---------------------------------------+------------------------------------------------+
| ``TEMPLATE/DEFAULT_VIEW``             | ``TEMPLATE/SUNSTONE/DEFAULT_VIEW``             |
+---------------------------------------+------------------------------------------------+
| ``TEMPLATE/GROUP_ADMIN_VIEWS``        | ``TEMPLATE/SUNSTONE/GROUP_ADMIN_VIEWS``        |
+---------------------------------------+------------------------------------------------+
| ``TEMPLATE/GROUP_ADMIN_DEFAULT_VIEW`` | ``TEMPLATE/SUNSTONE/GROUP_ADMIN_DEFAULT_VIEW`` |
+---------------------------------------+------------------------------------------------+

* VMTEMPLATE

+---------------------------------------+---------------------------------------+
| ``TEMPLATE/SUNSTONE_CAPACITY_SELECT`` | ``TEMPLATE/SUNSTONE/CAPACITY_SELECT`` |
+---------------------------------------+---------------------------------------+
| ``TEMPLATE/SUNSTONE_NETWORK_SELECT``  | ``TEMPLATE/SUNSTONE/NETWORK_SELECT``  |
+---------------------------------------+---------------------------------------+
