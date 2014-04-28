.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 4.4 users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`guide <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 4.6.

OpenNebula Administrators and Users
===================================

oZones and Federation
--------------------------------------------------------------------------------

oZones
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The **oZones** component has been deprecated, its funcitonality has been integrated into the main OpenNebula daemon. You can read more about the new **OpenNebula Federation** capabilities :ref:`here <introf>`. In a Federation, different OpenNebula instances share the same user accounts, groups, and permissions configuration.

Virtual Data Centers (vDC)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The **onevdc** command was part of the now deprecated **oZones** component. In 4.4, vDC provided a way to assign physical resources to groups, and to define a group administrator. These features have been extended and integrated into the core Group, so everything is managed through Sunstone and the CLI. You can read more about Groups, vDC, and Resource Providers in the :ref:`Group Management guides <manage_groups>` and the :ref:`Quickstart guide <qs_vdc>`.

Resource Providers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In previous versions, administrators could decide the physical resources exposed to each group using :ref:`ACL rules <manage_acl>`. In 4.6, this process has been simplified merging the oZones vDC functionality in the core.

There is a new concept: Resource Provider. A Resource Provider is an OpenNebula :ref:`cluster <cluster_guide>` (set of physical hosts and associated datastores and virtual networks) from a particular Zone (an OpenNebula instance). You can :ref:`assign/remove Resource Providers <managing-resource-provider-within-groups>` to each group, and internally that will create the ACL rules that you had to manually manage in 4.4.

When you upgrade from a previous version, the groups will not have any Resource Provider assigned. The existing ACL Rules are preserved, but they will not be interpreted as Resource Providers.

ACL Rules in a Federation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Each :ref:`ACL Rule <manage_acl>` now can define the Zone(s) where it applies.

.. code::

    $ oneacl create "@103 IMAGE/@100 USE #0"
    ID: 4

    $ oneacl create "@103 IMAGE/@102 USE *"
    ID: 5

    $ oneacl list
       ID     USER RES_VHNIUTGDCOZ   RID OPE_UMAC  ZONE
        4     @103     ---I-------  @100     u---    #0
        5     @103     ---I-------  @102     u---     *

Groups
--------------------------------------------------------------------------------

Group resources now have a template that can be edited, via Sunstone or with the ``onegroup update`` command.

The 4.4 configuration file ``group.default`` defined the ACL rules to create when new groups were created. This was the default ``group.default`` file:

.. code::

    # This rule allows users in the new group to create common resources
    VM+NET+IMAGE+TEMPLATE/* CREATE
    # This rule allows users in the group to deploy VMs in any host in the cloud
    HOST/* MANAGE

This file does not exist in 4.6, and the ACL rules are controlled with the :ref:`--resources option <manage_groups_permissions>` and Resource Providers.

    ``-r, --resources``: Defines the resources that can be created by group users (VM+IMAGE+TEMPLATE by default)

Users in new groups cannot deploy VMs until the admin assigns a :ref:`Resource Provider <managing-resource-provider-within-groups>`. To replicate the default 4.4 behaviour, assign the resource provider ALL:

.. code::

    $ onegroup add_provider <group_id> 0 ALL

.. note:: Note the difference in the default resources: users cannot create VNETs by default anymore.

Sunstone
--------------------------------------------------------------------------------

The Sunstone web interface has undergone a major redesign to make it more intuitive to use. There is more information available, new Views, and better creations wizards. You will not experience any incompatibility interaction with previous resources.

Sunstone Cloud View
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


* The Self-service Cloud View in OpenNebula 4.4 was a trimmed down version of the normal Sunstone. Now the users access a newly designed :ref:`Cloud View <cloud_view>`.
* The Templates for the 4.4 self-service cloud view **are not compatible** with the new 4.6 Cloud View.

  * In 4.4, self-service Templates were defined without the Disk, that the user could select at launch time.
  * For 4.6, Templates are complete i.e. can be instantiated without adding any attributes.

    The rationale behind this is:

  * The same Templates work for both the Cloud View and for administrators/advanced user views. There is no need to create specific Templates.
  * Allowing users to combine Templates with Images may end in non-functional VMs. For example, if you setup OS/ARCH to be 64bits a 64bit Image is needed.
  * It is quite difficult to combine the self-service Templates in 4.4 with advanced features like hybrid clouds. You need to tie somehow the local Image with the remote AMI. That can only be done at the Template level.

* The Cloud View Users can now save the changes they make to their VMs. This is a new action that combines a deferred disk snapshot with a template clone. Read more in the :ref:`vDC Admin View guide <vdc_admin_view_save>`.

Sunstone Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Available sunstone views for each user are now defined group-wise, instead of specifying it in ``sunstone-views.yaml`` (this file keeps the default view). Note, that there is no need to restart the Sunstone server when views are updated.
* The new Cloud view features predefined Instance types, that specify capacity values to instantiate the predefined VM templates. The instance types can be defined in ``sunstone-server.conf``.
* The ``admin.yaml`` and ``user.yaml`` views now have OneFlow visible by default. If you don't have OneFlow running, you'll see the message: 'Cannot connect to OneFlow server'. :ref:`Follow this section <sunstone_connect_oneflow>` to know more. Flow can be disables in ``sunstone-server.conf``.
* The communication between clients and Sunstone server has been reduced in this release to increase the overall performance (server-side). Just the active view periodically refresh its contents. This behavior is controlled by the ``autorefresh`` option in the yaml view definition file.
* Views should be compatible with Sunstone 4.6, note that ``autorefresh`` will be set to ``false`` for existing views.

Storage
-------

* The Datastore :ref:`BASE_PATH can be edited <ds_conf>` after the Datastore creation. You can also modify the base path of the default Datastores (0,1,2).
* Default Datastores (0,1,2) could not be deleted, or assigned to a Cluster up to 4.4. This limitation has been removed for the 4.6 release.
* OpenNebula can now operate with RBD Format 1 and RBD Format 2. RBD Format 2 brings many advantages, like creating new clones based on snapshots which runs a lot faster. If you want to take advantage of this you will need to manually convert your previously created images from RBD Format 1 to Format 2.
* For Ceph Datastores, you can specify the extra args sent to ``qemu-img convert`` in the ``/var/lib/one/remotes/datastore/ceph/ceph.conf```file. Adding ``-O rbd`` is recommended depening on the RBD version.

.. todo::

    * Feature #2202 Bring glusterfs support via libvirt integration

Monitoring
----------

.. todo:: * collectd shepherd.

Scheduling
--------------------------------------------------------------------------------

**Deprecated** attribute in sched.conf, ``HYPERVISOR_MEM``.

  ``HYPERVISOR_MEM``: Fraction of total MEMORY reserved for the hypervisor. E.g. 0.1 means that only 90% of the total MEMORY will be used.

The admin can now :ref:`update the Host information <host_guide_information>` to set a limit on the CPU and MEMORY available to OpenNebula. See the :ref:`Scheduler Guide <schg_limit>` for more information.

This functionality is somewhat similar the 4.4 ``HYPERVISOR_MEM`` attribute in ``sched.conf``. But it is more useful since the limitation applies to the complete OpenNebula system, not only to the Scheduler, and because it can be set for each Host individually.

* A new attribute has been included in sched.conf ``MESSAGE_SIZE`` to set the buffer size in bytes for XML-RPC responses. This can be increased in large clouds with a great number of VMs.

AppMarket
--------------------------------------------------------------------------------

In the new Appmarket version (>= 2) all the appliances can have multiple disks. This however does not affect the Sunstone workflow.

Contextualization
--------------------------------------------------------------------------------

.. todo::

    * cloud init?
    * Feature #2453 Add hostname configuration to contexualization

Econe
--------------------------------------------------------------------------------

.. todo:: * econe-register public_ip

Accounting: oneacct command
--------------------------------------------------------------------------------

The ``oneacct`` command now accepts the following options:

* ``--csv``: Writes the table in csv format
* ``--describe``: Describes the list columns
* ``-l, --list``: Selects the columns to display with list command

For example:

.. code::

    $ oneacct --list UID,HOSTNAME,CPU --csv

Virtual Networks
--------------------------------------------------------------------------------

* The following Virtual Network attributes can now be updated after the VNet creation:

  * ``PHYDEV``
  * ``VLAN``
  * ``VLAN_ID``
  * ``BRIDGE``

* Leases on hold can now be deleted.
* Up to 4.4, a Virtual Network could be deleted at any time even if there were VMs using IPs from that network. Now a Virtual Network cannot be deleted if there are leases in use.

oned.conf
--------------------------------------------------------------------------------

New attributes in :ref:`oned.conf <oned_conf>`:

* ``VM_INDIVIDUAL_MONITORING``: VM monitoring information is obtained along with the host information. For some custom monitor drivers you may need activate the individual VM monitoring process.
* ``FEDERATION``: Attributes to control the :ref:`federation config <oned_conf_federation>`.
* ``MESSAGE_SIZE``: Buffer size in bytes for XML-RPC responses. Only relevant for federation slave zones.
* ``RPC_LOG``: Create a separated log file for xml-rpc requests, in /var/log/one/one_xmlrpc.log.
* ``DEFAULT_CDROM_DEVICE_PREFIX``: Same as ``DEFAULT_DEVICE_PREFIX`` but for CDROM devices. Default value for DEV\_PREFIX field when it is omitted in a template.

oneflow-server.conf
--------------------------------------------------------------------------------

There is a new configuration attribute to customize the name given to the VMs created by oneflow. Read the :ref:`OneFlow Server Configuration guide <appflow_configure>` for more information

``:vm_name_template``: Default name for the Virtual Machines created by oneflow. You can use any of the following placeholders

* $SERVICE_ID
* $SERVICE_NAME
* $ROLE_NAME
* $VM_NUMBER

KVM
--------------------------------------------------------------------------------

There are new parameters for KVM machines. They can be seen in more detail at the :ref:`VM Template reference guide <_template>`:

* ``hyperv`` feature to give better support to Windows machines. Its paramaters can be changed in the driver configuration file (``/etc/one/vmm_exec/vmm_exec_kvm.conf``).
* ``localtime`` feature so the clock reported to the VM is in local time and not UTC.
* When selecting spice support some other parameters are added to the VM. These can be changed in the driver configuration file (``/etc/one/vmm_exec/vmm_exec_kvm.conf``).
* Add default ``GRAPHICS`` section parameters, configurable in the driver configuration file (``/etc/one/vmm_exec/vmm_exec_kvm.conf``).
* ``machine`` option in the ``OS`` section. This is useful for migration between different host OS versions and to select other chipset than the default one.


Xen
--------------------------------------------------------------------------------

.. todo:: * Feature #1762 Implement Xen FEATURES

Developers and Integrators
==========================

Monitoring
----------

* Individual VM monitoring has been disabled by default for stock monitoring drivers. These drivers include VM information along with the hypervisor one. As the VM information is also obtained (in general) through the hypervisor, a failure may collapse VM actions. If you have develop a driver that relies on individual VM monitoring, you can enable it in ``oned.conf`` (attribute ``VM_INDIVIDUAL_MONITORING``)

Ruby OCA
--------------------------------------------------------------------------------

.. todo:: * Feature #2732 Support for http proxy in ruby oca client


XML-RPC API
--------------------------------------------------------------------------------

.. todo:: * Feature #2371 Paginate the .info API responses

* New api calls:

  * ``one.group.update``: Replaces the group template contents.
  * ``one.group.addprovider``: Adds a resource provider to the group.
  * ``one.group.delprovider``: Deletes a resource provider from the group.
  * ``one.zone.allocate``: Allocates a new zone in OpenNebula.
  * ``one.zone.delete``: Deletes the given zone from the pool.
  * ``one.zone.update``: Replaces the zone template contents.
  * ``one.zone.rename``: Renames a zone.
  * ``one.zone.info``: Retrieves information for the zone.
  * ``one.zonepool.info``: Retrieves information for all the zones in the pool.

* Changed api calls:

  * ``one.vm.savedisk``: New optional parameter. Boolean, True to clone clone also the VM originating Template, and replace the disk with the saved image.
