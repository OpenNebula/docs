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

.. todo::

    * New system to assign views to users/groups
    * Instance types
    * autorefresh in yaml files
    * compatibility of view yaml files?
    * Flow enabled by default


Storage
-------

* The Datastore :ref:`BASE_PATH can be edited <ds_conf>` after the Datastore creation. You can also modify the base path of the default Datastores (0,1,2).
* Default Datastores (0,1,2) could not be deleted, or assigned to a Cluster up to 4.4. This limitation has been removed for the 4.6 release.

.. todo::

    * RBD_FORMAT
    * QEMU_IMG_CONVERT_ARGS
    * Feature #2568 Support for RBD Format 2 images
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

.. todo:: * MESSAGE_SIZE

Marketplace
--------------------------------------------------------------------------------

.. todo::

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

Group
--------------------------------------------------------------------------------

Group resources now have a template that can be edited, via Sunstone or with the ``onegroup update`` command.

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

CLI configuration
--------------------------------------------------------------------------------

.. todo:: * group.default removed. ACL rules are defined with options

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

.. todo::
  * Feature #2567 KVM Hyper-V Enlightenments
  * Feature #2547 Support libvirt "localtime" parameter for Windows KVM guest template
  * Feature #2485 Configuring SPICE should enable qxl paravirtual graphic card
  * Feature #2247 Graphics section in vmm_exec_kvm.conf
  * Feature #2143 Add machine type to KVM deployment file

Xen
--------------------------------------------------------------------------------

.. todo:: * Feature #1762 Implement Xen FEATURES

Developers and Integrators
==========================

Monitoring
----------

.. todo:: * New requirement: return vm poll in host im drivers


Ruby OCA
--------------------------------------------------------------------------------

.. todo:: * Feature #2732 Support for http proxy in ruby oca client


XML-RPC API
--------------------------------------------------------------------------------

.. todo::

* Feature #2371 Paginate the .info API responses
* New api calls:

  * ...

* Changed api calls:

  * ...
