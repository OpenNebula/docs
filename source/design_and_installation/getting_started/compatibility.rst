.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 4.2 users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`guide <upgrade>`

Visit the :ref:`Features list <features>` and the :ref:`Release Notes <software:software>` for a comprehensive list of what's new in OpenNebula 4.4.

OpenNebula Administrators and Users
===================================

Add-ons Catalog
---------------

- There is a new initiative to host `OpenNebula add-ons in github <http://github.com/OpenNebula>`__. There you will find community-contributed components that may not be mature enough, or not general-purpose enough to be included in the main distribution.

Sunstone
--------

-  The rows in the datatables are now ordered by ID in descending order. This behaviour can be changed by user in the settings dialog or by default in :ref:`sunstone-server.conf <sunstone#sunstone-serverconf>`.

Users and Groups
----------------

-  New :ref:`secondary groups <manage_users#primary_and_secondary_groups>`. These work in a similar way to the unix groups: users will have a primary group, and optionally several secondary groups. This new feature is completely integrated with the current mechanisms allowing, for example, to perform the following actions:

   -  The list of images visible to a user contains all the images shared within any of his groups.
   -  You can deploy a VM using an Image from one of your groups, and a second Image from another group.
   -  New resources are created in the owner’s primary group, but users can later change that resource’s group.
   -  Users can change their primary group to any of their secondary ones.

-  The quota subsystem now supports volatile disk usage and limit, see :ref:`the VOLATILE\_SIZE attribute here <quota_auth>`.

Scheduling
----------

-  There is a new :ref:`default scheduling policy <schg#configuration>` for both hosts and datastores: ``fixed``. This policy will rank hosts and datastores according looking for a ``PRIORITY`` attribute that can be set manually by the administrator.

Virtual Machines
----------------

-  The :ref:`''shutdown --hard'' action <vm_guide_2>` can be performed on UNKNOWN VMs. This means that if the guest was shutdown from within or crashed, users can still save the persistent or snapshotted disks.
-  The default device prefix, ``DEV_PREFIX``, is now 'hd' for cdrom type disks, regardless of the value set in :ref:`oned.conf <oned_conf#datastores>`.

Contextualization
-----------------

-  Support for cloud init: now OpenNebula is able to contextualize guests using :ref:`cloud init <cloud-init>`.
-  Improvements in contextualization: ability to add INIT\_SCRIPTS. Check :ref:`this guide <cong#defining_context>` to learn how to define contextualization in your VM templates.

Storage
-------

-  Multiple system datastores: enables a much more efficient usage of the storage resources for running Virtual Machines. :ref:`Read this to configure and use this new feature <system_ds#multiple_system_datastore_setups>`.
-  Now that VMs can be deployed in different system DS for each host, the :ref:`scheduler algorithm <schg#the_match-making_scheduler>` has been extended to take storage into account.
-  The amount of storage used by OpenNebula can be limited for each Datastore using the :ref:`new attribute LIMIT\_MB <ds_conf>`.

Resource Management
-------------------

-  Support rename for more resources: users can now rename `hosts <http://opennebula.org/doc/4.4/cli/onehost.1.html>`__, `vnets <http://opennebula.org/doc/4.4/cli/onevnet.1.html>`__ and `datastores <http://opennebula.org/doc/4.4/cli/onedatastore.1.html>`__.

Monitoring
----------

-  New monitorization model: changed from a pull model to a push model, thus increasing the scalability of an OpenNebula cloud. :ref:`More information here <rel4.4:img#monitoring_models>`.

Developers and Integrators
==========================

Monitoring
----------

-  Ganglia drivers have been moved out of the main OpenNebula distribution and are available as an `addon <https://github.com/OpenNebula/addon-ganglia>`__.
-  The arguments of the im\_mad poll action drivers have changed, you can see the complete reference in the :ref:`Information Manager Driver guide <devel-im>`.

.. code::

    # 4.2 arguments
    hypervisor=$1
    host_id=$2
    host_name=$3
     
    # 4.4 arguments
    hypervisor=$1
    datastore_location=$2
    collectd_port=$3
    monitor_push_cycle=$4
    host_id=$5
    host_name=$6

-  Probes returning float values will be ignored (set to 0), they must be integer.

Storage
-------

-  Changes in :ref:`Ceph <ceph_ds>`, :ref:`SCSI <iscsi_ds>` and :ref:`LVM <lvm_ds>` Datastores. Now the :ref:`''BRIDGE\_LIST'' attribute is mandatory <ds_conf>` in the template used to create these type of datastores.
-  CephX support. More information :ref:`here <ceph_ds>`.
-  CDROM images are no longer cloned. This makes VM instantiation faster when a big DVD is attached.
-  iscsi drivers have been moved out of the main OpenNebula distribution and are available as an `addon <https://github.com/OpenNebula/addon-iscsi>`__.
-  New LVM drivers model: the shared KVM model, as well as support for compressed images in LVM. :ref:`Check more info on the new model here <lvm_drivers>`.

EC2 Hybrid Cloud / Cloudbursting
--------------------------------

-  `AWS SDK Ruby <http://aws.amazon.com/sdkforruby/>`__ is used instead of the Java CLI.
-  The ``ec2.conf`` file was renamed to :ref:`ec2\_driver.default <ec2g>`. In this file you can define the default values for ec2 instances.
-  The ``ec2rc`` file has been removed. A new configuration file is available: ``ec2_driver.conf``.
-  Now AWS credentials and regions can be defined per host instead of specifying them in the driver configuration in oned.conf. You can customise these values in ``ec2_driver.conf``. :ref:`More info <ec2g#multi_ec2_site_region_account_support>`
-  The ``CLOUD`` attribute has been deprecated, now you have to use ``HOST`` to define more than one EC2 sections in the template. :ref:`More info <ec2g#multi_ec2_site_region_account_support>`
-  The following EC2 template attributes have been removed:

   -  ``AUTHORIZED_PORTS``: we removed it because the right approach is to use SECURITY\_GROUPS. What OpenNebula was doing was to modify the default security group, but we now think that a much better approach is to achieve the same using different SECURITY GROUPS and assigning VMs to them.
   -  ``USERDATAFILE``: OpenNebula 4.4 is dropping support due to a security risk, it allowed practically everyone to retrieve files from the OpenNebula front-end and stage them into an Amazon EC2 VM. The alternative is to read the file and set its contents into the ``USERDATA`` attribute, which is still supported.

-  Now the VM monitoring provides more info. New tags that can be accessed inside each VM:

.. code::

    AWS_DNS_NAME
    AWS_PRIVATE_DNS_NAME
    AWS_KEY_NAME
    AWS_AVAILABILITY_ZONE
    AWS_PLATFORM
    AWS_VPC_ID
    AWS_PRIVATE_IP_ADDRESS
    AWS_IP_ADDRESS
    AWS_SUBNET_ID
    AWS_SECURITY_GROUPS
    AWS_INSTANCE_TYPE

-  The ``IPADDRESS`` monitoring attribute has been renamed to ``AWS_PRIVATE_IP_ADDRESS``.

Generic Hybrid Cloud / Cloudbursting
------------------------------------

-  There is better support for custom cloud bursting drivers, you can read more in :ref:`this guide <devel-cloudbursting>`.
-  im\_mad drivers must return PUBLIC\_CLOUD=YES
-  There is a new generic attribute for VMs: ``PUBLIC_CLOUD``. This allows users to create templates that can be run locally, or in different public cloud providers. Public cloud vmm drivers must make use of this:

.. code::

      DISK = [ IMAGE_ID = 7 ]

      PUBLIC_CLOUD = [
        TYPE         = "jclouds",
        JCLOUDS_DATA = "..." ]

      PUBLIC_CLOUD = [
        TYPE    = "ec2",
        AMI     = "...",
        KEYPAIR = "..." ]

EC2 Server
----------

-  Now instance types are based on OpenNebula templates instead of files. You can still use the old system, changing the ``:use_file_templates:`` parameter in :ref:`econe.conf <ec2qcg#configuration>`. But using the new system is recommended, since file based templates will be removed soon.
-  New implemented methods:

   -  describe-snapshots
   -  create-snapshot
   -  delete-snapshot
   -  create-tags: for instances, amis, volumes and snapshots
   -  describe-tags
   -  remove-tags

-  Enhanced methods:

   -  describe-\*: one or more IDS can be specified now
   -  describe-instances: includes vms in DONE for 15 minutes. You can configure this behaviour in the conf.
   -  register: now you have to use this command to use an opennebula image in ec2. Missing features that will be added: add arch, kernel, extra disks metadata.
   -  create-volume: now you can create a volume from an snapshot
   -  run-instance: now instead of using erb files templates are based on opennebula templates. Therefore you can use restricted attributes and set permissions like any other opennebula resource.

-  econe-\* tools are no longer maintained, you can use euca2ools or hybridfox to test the new functionality

XML-RPC API
-----------

-  Improved scalability: new parameters support in oned.conf for xmlrpc parameters. :ref:`xml-rpc\_server\_configuration <oned_conf#xml-rpc_server_configuration>`.

   -  MAX\_CONN: Maximum number of simultaneous TCP connections the server will maintain
   -  MAX\_CONN\_BACKLOG: Maximum number of TCP connections the operating system will accept on the server's behalf without the server accepting them from the operating system
   -  KEEPALIVE\_TIMEOUT: Maximum time in seconds that the server allows a connection to be open between RPCs
   -  KEEPALIVE\_MAX\_CONN: Maximum number of RPCs that the server will execute on a single connection
   -  TIMEOUT: Maximum time in seconds the server will wait for the client to do anything while processing an RPC

-  New parameter in :ref:`one.vm.deploy <api#onevmdeploy>`

   -  The Datastore ID of the target system datastore where the VM will be deployed. It is optional, and can be set to -1 to let OpenNebula choose the datastore.

-  New method :ref:`one.user.addgroup <api#oneuseraddgroup>`
-  New method :ref:`one.user.delgroup <api#oneuserdelgroup>`
-  New method :ref:`one.host.rename <api#onehostrename>`
-  New method :ref:`one.datastore.rename <api#onedatastorerename>`
-  New method :ref:`one.cluster.rename <api#oneclusterrename>`

