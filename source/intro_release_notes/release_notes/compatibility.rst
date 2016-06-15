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

The **Block LVM** Storage driver is no longer included in the main distribution. It can be however manually installed through the `LVM Add-on <https://github.com/OpenNebula/addon-lvm>`__.

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

Disk Snapshots
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Virtual Machines in RUNNING state can now take disk snapshots if the drivers support it (kvm with ceph or qcow2), otherwise the VM needs to be manually powered off or suspended. Similarly, the disk snapshot revert operation requires the VM to be powered off or suspended. The strategy option has been removed from the VMM drivers, as well as the DISK_SNAPSHOT_REVERT state (for VMs doing a snapshot operation while RUNNING).

VNC Ports
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

VNC port assignment has been improved in 5.0 to support TCP port reservations and to better reuse the port pool. The VNC port is checked now at the cluster level and not zone-wise, so a VM can be deployed/migrated in/to any host in the selected cluster. The automatic port selection assignment will first try ``VNC_PORTS[START] + VMID`` as in previous versions. Moreover, in this new version if the user sets a port its availability is first checked. ``VNC_BASE_PORT`` attribute in ``oned.conf`` has been changed to ``VNC_PORTS`` to include also a set of reserved ports. See :ref:`the oned.conf reference <oned_conf>` for more information.

Context
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Context is now generated whenever a VirtualMachine is started in a host, i.e. when the deploy or restore action is invoked or when a NIC is attached/detached from the VM. This means that a new attached NIC will have the IP properly configured.

Shutdown and Delete actions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``onevm shutdown (--hard)`` action has been renamed to ``onevm terminate (--hard)``. This action can be executed from almost any state, except those where the VM is waiting for a driver operation to finish.

The ``onevm delete (--recreate)`` action has been removed. End-users can execute the new ``onevm terminate --hard`` action to remove the VM completely from any state. When a VM is stuck in a state where ``terminate`` is not available, the cloud administrator can perform an immediate delete with the new ``onevm recover --delete/--recreate`` options.

For more information, read the :ref:`Managing Virtual Machines section <vm_instances>`.

Instantiate a Persistent Copy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

OpenNebula 4.14 had the ``onevm save`` command to save a VM instance into a new VM Template. In the 5.0 release we have added the possibility to instantiate as persistent with the ``onetemplate instantiate --persistent`` command. This creates a Template copy (plus a persistent copy of each disk image) and instantiates that copy.

Description & Features
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

OpenNebula now allows to set an arbitrary boot order from any device. The ``BOOT`` attribute semantic has been updated to implement this new feature. The previous ``hd,net,cdrom`` will be ignored.

Moreover, the boot order as well as other configuration attributes can be updated now in poweroff state, so easing the workflow for new VM installation and recovery.

A shortcut option to automatically include support for the qemu guest agent has been added to OpenNebula. There is no need to add RAW attributes to add agent support to a VM.

Cloud Bursting
--------------------------------------------------------------------------------

The following valid syntax in 4.14 EC2 VM Templates has been deprecated:

.. code::

    EC2=[AMI="xxx", ...]

In 5.0 Wizard the only valid syntax is using PUBLIC_CLOUD with the attributes defined in the :ref:`Amazon EC2 Driver Section <ec2_specific_temaplate_attributes>`.

The existing VM Templates with the old EC2 Section will be automatically modified with the new syntax by the onedb upgrade command.

Scheduler
--------------------------------------------------------------------------------

The scheduler now considers secondary groups to schedule VMs for both hosts and
datastores (see `feature #4156 <http://dev.opennebula.org/issues/4156>`_). This
feature enable users to effectively use multiple VDCs. This may **only** affect
to installations using multiple groups per user.

Clusters
--------------------------------------------------------------------------------

In 5.0 we have introduced to possibility to add Datastores and VNets to more than one cluster. At the same time, we have eliminated the 'none' (-1) cluster.

In OpenNebula 4.14 this special cluster none was used to share Datastores and VNets across all clusters. In 5.0 the resources outside of any cluster are "disabled for new deployments" from the scheduler's point of view. You will need to explicitly add your resources to all the clusters that are configured to use those Datastores and VNets.

Hosts
--------------------------------------------------------------------------------

A new state offline has been added to manage a host life-cycle. This new state completely sets the host offline. It differs from disable state, where hosts are still monitored.

Storage and Datastores
--------------------------------------------------------------------------------

BASE_PATH has been deprecated
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The attribute ``BASE_PATH`` has been deprecated and removed from the interface. If it was defined in the Datastore templates, it has now been removed. This means, that everything is now built on ``DATASTORE_LOCATION`` as defined in ``oned.conf``, which defaults to ``/var/lib/one/datastores``. If you were using a different ``BASE_PATH``, you will need to create a symbolic link in your nodes to fix that mountpoint. Something along the lines of: ``ln -s <BASE_PATH> /var/lib/one/datastores``.

FSTYPE has been deprecated
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Datablocks and Volatile Disks can now only be ``raw`` or ``qcow2`` (and ``swap`` for volatile disks). They will be created as blocks and no filesystem will be created inside. The options like ``ext3, ext4, vfat, etc`` are not supported any more. Furthermore, the attribute ``FSTYPE`` has been deprecated. The logic is the following:

* New Empty Datablock:

  * ``if DRIVER == qcow2`` => The block will be created as ``qcow2``.
  * ``if DRIVER != qcow2`` => The block will be created as ``raw``.
  * ``if DRIVER is empty && TM_MAD == qcow2`` => The block will be created as ``qcow2``.
  * ``if DRIVER is empty && TM_MAD != qcow2`` => The block will be created as ``raw``.

* Volatile Disk:

  * Same logic as above, except if ``TYPE == swap``.
  * ``if TYPE == swap`` => The block will be created as ``raw`` and formatted as ``swap`` (regardless if the ``TM_MAD == qcow2``).

SOURCE does not support the http protocol
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Before 5.0, it was possible to register images without a ``PATH`` attribute, by manually setting the ``SOURCE`` attribute instead. This could only be defined by oneadmin, and it was a restricted attribute. This ``SOURCE`` attribute could be an http link, instead of a path. In 5.0, having an http link as a source for an image is not supported anymore. If you run ``oneimage list -x|grep SOURCE|grep http`` and you see something displayed, the image with that ``SOURCE`` will not work.

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

Virtual Network drivers are now defined per vnet. This allow to implement multiple vnet types from the same host. The migration process should take care of this automatically, although it may request manual input on some corner cases. Any third-party tool that creates hosts or virtual networks must be updated accordingly.

The previous change makes the ``VLAN`` attribute useless and it will be removed from any virtual network. Third-party network drivers using this attribute should be updated.

Sunstone
--------------------------------------------------------------------------------

Groupadmin View
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Sunstone's 4.14 'groupadmin' view was similar to the 'cloud' view, but with added functionality to manage users and quotas. In 5.0 we have decided to redesign the 'groupadmin' view, and now its layout is based on the advanced 'admin' view.

Group administrators still have a limited set of available actions and a limited view of the cloud, restricted to their group's resources. The main difference in terms of what they can do is the access to the virtual network information and virtual routers creation.

Group admin users can also access the simplified 'cloud' view, but only to manage VMs and Services. The administrative features are only available in the 'groupadmin' view.

Read more about the different :ref:`Sunstone views following this link <suns_views>`.

Instance Types
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Instance types, not available anymore in OpenNebula 5.0, allowed the administrators to define different VM capacity sizes. In 5.0 the capacity can be edited, but each VM Template defines the modification allowed.

While instance types were only available to users of the Sunstone 'cloud' view, the new modification is made available when the VM Template is instantiated from any of the Sunstone views and the CLI. Read more in the :ref:`Virtual Machine Templates documentation <vm_templates_endusers>`.

Developers and Integrators
================================================================================

Transfer Manager
--------------------------------------------------------------------------------

The monitoring process of the storage resources has been greatly improved and optimized: System datastores are now monitored as any other datastore. Third-party datastore drivers needs to implement the monitor script to return this value to oned. Also disk usage monitoring from VMs has been also improved to allow thrid-party TM drivers to include their own monitor scripts, :ref:`see the storage integration section for details <ds_monitor>`


Virtual Machine Manager
--------------------------------------------------------------------------------

Context is now generated whenever a VirtualMachine is started in a host, i.e. when the deploy or restore action is invoked or when a NIC is attached/detached from the VM. Driver integrators may want to implement the :ref:`reconfigure VMM driver action <devel-vmm>`. This new action notifies a running VM that the context has changed and needs to reconfigure its NICs.

Sunstone
--------------------------------------------------------------------------------

All the SUNSTONE specific information in VM Template, Group, User and other object templates has been arranged in a vector attribute like:

**USER**

+----------------------------------------+-------------------------------------------------+
|             4.14 Attribute             |                  5.0 Attribute                  |
+========================================+=================================================+
| ``TEMPLATE/SUNSTONE_DISPLAY_NAME``     | ``TEMPLATE/SUNSTONE/DISPLAY_NAME``              |
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

**GROUP**

+---------------------------------------+------------------------------------------------+
|             4.14 Attribute            |                 5.0 Attribute                  |
+=======================================+================================================+
| ``TEMPLATE/SUNSTONE_VIEWS``           | ``TEMPLATE/SUNSTONE/VIEWS``                    |
+---------------------------------------+------------------------------------------------+
| ``TEMPLATE/DEFAULT_VIEW``             | ``TEMPLATE/SUNSTONE/DEFAULT_VIEW``             |
+---------------------------------------+------------------------------------------------+
| ``TEMPLATE/GROUP_ADMIN_VIEWS``        | ``TEMPLATE/SUNSTONE/GROUP_ADMIN_VIEWS``        |
+---------------------------------------+------------------------------------------------+
| ``TEMPLATE/GROUP_ADMIN_DEFAULT_VIEW`` | ``TEMPLATE/SUNSTONE/GROUP_ADMIN_DEFAULT_VIEW`` |
+---------------------------------------+------------------------------------------------+

**VMTEMPLATE**

+---------------------------------------+---------------------------------------+
|             4.14 Attribute            |             5.0 Attribute             |
+=======================================+=======================================+
| ``TEMPLATE/SUNSTONE_CAPACITY_SELECT`` | ``TEMPLATE/SUNSTONE/CAPACITY_SELECT`` |
+---------------------------------------+---------------------------------------+
| ``TEMPLATE/SUNSTONE_NETWORK_SELECT``  | ``TEMPLATE/SUNSTONE/NETWORK_SELECT``  |
+---------------------------------------+---------------------------------------+
