.. _whats_new:

================================================================================
What's New in 5.6
================================================================================


OpenNebula Core
--------------------------------------------------------------------------------

.. - **New HA model**, providing native HA (based on RAFT consensus algorithm) in OpenNebula components, including Sunstone without :ref:`third party dependencies <frontend_ha_setup>`.

- **Support to set CPU model**: The CPU model can be now set. Available modes are obtained through monitor, and stored in the hosts.
- **Improved Monitoring**: several synchronization points have been removed from one to improve concurrencry in the monitoring process. Also database connections are now configurable to allow more parallel access to the the database.
- **Default permission for ACLs**: The uses can specify the default permission for the automatic ACLs. :ref:`oned.conf <oned_conf>`.

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

|sched_actions|

- **Display quotas in Clod View**, the end-user can see his quotas in real time.
- **Turkish language (TR)**, now in Sunstone.
- **Icons makeover**, Font Awesome has been updated to lastest version!.


vCenter
--------------------------------------------------------------------------------

- **Multiple cluster network support**: now it is possible to import networks belonging to more than 1 cluster with a better management, also you won't see duplicated networks anymore.
- **vCenter cluster migration**: migrate your vms between vCenter clusters with OpenNebula.

Log
--------------------------------------------------------------------------------

- **Lock resources**, the user can lock resources (vms, images or networks) to prevent unintended operations.
- **Relative actions**, the user can schedule relative actiones.
- **API request logs**: Now admins can specify how many characters are used to print each parameter in the oned.log.

.. |sunstone_dashboard| image:: /images/sunstone_dashboard.png
.. |sched_actions| image:: /images/sched_actions.png
