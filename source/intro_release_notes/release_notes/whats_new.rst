.. _whats_new:

================================================================================
What's New in 5.6
================================================================================


OpenNebula Core
--------------------------------------------------------------------------------

.. - **New HA model**, providing native HA (based on RAFT consensus algorithm) in OpenNebula components, including Sunstone without :ref:`third party dependencies <frontend_ha_setup>`.

- **Support to set CPU model**: The CPU model can be now set. Available modes are obtained through monitor, and stored in the hosts.
- **Improved Monitoring**: several synchronization points have been removed from one to improve concurrencry in the monitoring process. Also database connections are now configurable to allow more parallel access to the the database.
- **Default permission for VDC ACLs**: Administrator can specify the default permission for the automatic ACLs created when a resource is added to a VDC. :ref:`oned.conf <oned_conf>`.
- **Create as uid/gid**: Now users can define which will be the owner or group for a VM when instantiating a VM Template. :ref:`See more information here <instantiate_as_uid_gid>`.
- **More IO throttling attributes**: We have added more attribute to define IO throttling support into disk section. :ref:`See more information here <reference_vm_template_disk_section>`.

Storage
--------------------------------------------------------------------------------

- **Deploy the images wherever you want**: We have added the possibility to select different deployment modes for Image datastores. For example the same Ceph Image can be used directly from the pool (default ceph mode) or run from the hypervisor local storage (ssh mode). :ref:`More info. <ceph_ds>`. Also shared Filesystem datastores can be combined with the host local storage (ssh mode). :ref:`More indo.<fs_ds>`

Networking
--------------------------------------------------------------------------------

- Better support for security group rules with a large number of ports. :ref:`See configuration options here <bridged_conf>`.
- **Open vSwitch** rules for the ARP/MAC/IP spoofing filters were refactored.
- New **Open vSwitch on VXLAN** driver. Driver :ref:`ovswitch_vxlan <openvswitch_vxlan>`.

Hybrid Clouds: Amazon EC2
--------------------------------------------------------------------------------

Hybrid Clouds: One-to-One
--------------------------------------------------------------------------------

- **One to One**, the users will can deploying VMs on a remote OpenNebula from local OpenNebula. :ref:`Driver one-to-one <oneg>`.

Scheduler
--------------------------------------------------------------------------------

- **Memory system datastore scale**, This factor scales the VM usage of the system DS with the memory size. :ref:`Scheduler configuration <schg_configuration>`.

Sunstone
--------------------------------------------------------------------------------

- **New dashboard**, intuitive, fast and light. The new dashboard will perform better on large deployments.

|sunstone_dashboard|

- **KVM and vCenter more united than ever**, a single view to control the two hypervisors. :ref:`Completely customizable views <suns_views>`.
- **Scheduled Actions** can now be defined in VM Template create and instantiate dialogs. :ref:`More info <sched_actions_templ>`.
- **Display quotas in Clod View**, the end-user can see his quotas in real time.
- **Turkish language (TR)**, now in Sunstone.
- **New global configurations**. To be able to customize Sunstone even more, :ref:`there are new features in the yamls <suns_views_custom>`.
- **Disk resize in the cloud view**. Now you can resize a disk as a user cloud.

|sched_actions|

- **Display quotas in Clod View**, the end-user can see his quotas in real time.
- **Turkish language (TR)**, now in Sunstone.
- **Icons makeover**, Font Awesome has been updated to lastest version!.


- **Timeout option for xmlrpc calls**, you can add this new option inside :ref:`sunstone-server.conf <sunstone_setup>`, now it's possible to configure the timeout of OpenNebula XMLRPC for all operations from sunstone.

.. code::

    # sets the timeout for xmlrpc calls to 80 seconds
    #
    :one_xmlrpc_timeout: 80

vCenter
--------------------------------------------------------------------------------

- **Multiple cluster network support**: now it is possible to import networks belonging to more than 1 cluster with a better management, also you won't see duplicated networks anymore.
- **vCenter cluster migration**: migrate your vms between vCenter clusters with OpenNebula.
- **vCenter Marketplace**: now it's available the HTTP and S3 Marketplaces for vCenter datastores.

API & CLI
--------------------------------------------------------------------------------
- **zone show**: users can view all information of HA servers with the option `-x`. The Zone::info_extended() method exposes this functionality to be used by other tools (only in Ruby OCA).

Log
--------------------------------------------------------------------------------
- **API request logs**: Now admins can specify how many characters are used to print each parameter in the oned.log.

- **Lock resources**, the user can lock resources (vms, images or networks) to prevent unintended operations.
- **Relative actions**, the user can schedule relative actiones.

.. |sunstone_dashboard| image:: /images/sunstone_dashboard.png
.. |sched_actions| image:: /images/sched_actions.png
