.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 4.14.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`guide <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 4.14.

OpenNebula Administrators and Users
================================================================================

OpenNebula Daemon
--------------------------------------------------------------------------------

The logging facilities has been updated to get rid of the log4cpp dependencies.
Although the format of the messages has been preserved you may need to double
check any tool parsing directly syslog messages. Also a new log facility has been
included (std) that uses the stderr stream.

Context is now generated whenever a VirtualMachine is started in a host, i.e. when the deploy or restore action is invoked or when a NIC is attached/detached from tthe VM. This should be transparent for users, driver integrators may want to implement the reconfigure VMM driver action. This new action notifies a running VM that the context has changed and needs to reconfigure its NICs.

Virutal Machine Management
--------------------------------------------------------------------------------
Virtual Machines in RUNNING state can take disk snapshots if the drivers support it (kvm with ceph or qcow2) otherwise the VM needs to be manually powered off or suspended. Similarly, disk snapshot revert operation requires the VM to be powered off or suspended. The strategy option has been removed from the VMM drivers, as well as the DISK_SNAPSHOT_REVERT state (for VMs doing a snapshot operation while RUNNING).

VNC port assignment has been improved in 5.0 to support TCP port reservations and to better reuse the port pool. The VNC port is checked now at the cluster level and not zone-wise, so a VM can be deployed/migrated in/to any host in the selected cluster. The automatic port selection assignment will first try ``VNC_PORTS[START] + VMID`` as in previous versions. Moreover, in this new version if the user sets a port its availability is first checked. ``VNC_BASE_PORT`` attribute in ``oned.conf`` has been changed to ``VNC_PORTS`` to include also a set of reserved ports.

Scheduler
--------------------------------------------------------------------------------

The scheduler now considers secondary groups to schedule VMs for both hosts and
datastores (see `feature #4156 <http://dev.opennebula.org/issues/4156>`_). This
feature enable users to effectively use multiple VDCs. This may **only** affect
to installation using multiple groups per user.

Clusters
--------------------------------------------------------------------------------

In 5.0 we have introduced to possibility to add Datastores and VNets to more than one cluster. At the same time, we have elimitated the 'none' (-1) cluster.

In OpenNebula 4.14 this special cluster none was used to share Datastores and VNets across all clusters. In 5.0 the resources outside of any cluster are "disabled for new deployments" from the scheduler's point of view. You will need to explicity add your resources to all the clusters that are configured to use those Datastores and VNets.

Disk Templates
--------------------------------------------------------------------------------

Any attribute defined explicitly in the ``DISK`` section of a Template or of a Virtual Machine template, will **not** be overridden by the same attribute defined in the Image template or in the Datastore template, even if the attribute is marked as ``INHERIT`` in ``oned.conf``. The precedence of the attributes is evaluated in this order (most important to least important):

- ``DISK`` section of the Template
- Image template
- Datastore template

Virtual Networks
--------------------------------------------------------------------------------

Before OpenNebula 5.0, when doing reservations of Virtual Networks with VLAN isolation, but without the VLAN_ID parameter, the VLAN_ID of the reservation and of the parent network where not the space, meaning that they were isolated from one another. This behaviour has been fixed in OpenNebula >= 5.0: the reservation will inherit the same VLAN_ID as the parent. Note that this will affect only newly created Virtual Machines, the old ones will exhibit the old behaviour.

The old ``fw`` driver has been removed from OpenNebula (it was deprecated in OpenNebual 4.12). If you are still using it, we recommended that you remove those VMs. After the upgrade to 5.0, OpenNebula will not create/modify/remove any of the iptables rules related to the ``fw`` driver. The database migration utility ``onedb`` will detect if you still have any VMs using this functionality. In any case, please switch to :ref:`Security Groups <security_groups>` which deliver more functionality than the old ``fw`` driver.

Sunstone
--------------------------------------------------------------------------------

All the SUNSTONE specific information in VM Template, Group, User and other object templates has been arranged in a vector attribute like:

* USER

TEMPLATE/SUNSTONE_DISPLAY_NAME > TEMPLATE/SUNSTONE/DISPLAY_NAME
TEMPLATE/LANG > TEMPLATE/SUNSTONE/LANG
TEMPLATE/TABLE_DEFAULT_PAGE_LENGTH > TEMPLATE/SUNSTONE/TABLE_DEFAULT_PAGE_LENGTH
TEMPLATE/TABLE_ORDER > TEMPLATE/SUNSTONE/TABLE_ORDER
TEMPLATE/DEFAULT_VIEW > TEMPLATE/SUNSTONE/DEFAULT_VIEW
TEMPLATE/GROUP_ADMIN_DEFAULT_VIEW > TEMPLATE/SUNSTONE/GROUP_ADMIN_DEFAULT_VIEW

* GROUP

TEMPLATE/SUNSTONE_VIEWS > TEMPLATE/SUNSTONE/VIEWS
TEMPLATE/DEFAULT_VIEW > TEMPLATE/SUNSTONE/DEFAULT_VIEW
TEMPLATE/GROUP_ADMIN_VIEWS > TEMPLATE/SUNSTONE/GROUP_ADMIN_VIEWS
TEMPLATE/GROUP_ADMIN_DEFAULT_VIEW > TEMPLATE/SUNSTONE/GROUP_ADMIN_DEFAULT_VIEW

* VMTEMPLATE

TEMPLATE/SUNSTONE_CAPACITY_SELECT > TEMPLATE/SUNSTONE/CAPACITY_SELECT
TEMPLATE/SUNSTONE_NETWORK_SELECT > TEMPLATE/SUNSTONE/NETWORK_SELECT


Developers and Integrators
================================================================================

Transfer Manager
--------------------------------------------------------------------------------

**TODO** New monitor script for system datastores
