.. _whats_new:

================================================================================
What's New in 5.6
================================================================================


OpenNebula Core
--------------------------------------------------------------------------------

.. - **New HA model**, providing native HA (based on RAFT consensus algorithm) in OpenNebula components, including Sunstone without :ref:`third party dependencies <frontend_ha_setup>`.

- **Support to set CPU model**: The CPU model can be now set. Available modes are obtained through monitor, and stored in the hosts.

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


Sunstone
--------------------------------------------------------------------------------

- **New dashboard**, intuitive, fast and light. The new dashboard will perform better on large deployments.

|sunstone_dashboard|

- **KVM and vCenter more united than ever**, a single view to control the two hypervisors. :ref:`Completely customizable views <suns_views>`.
- **Scheduled Actions** can now be defined in VM Template create and instantiate dialogs. :ref:`More info <sched_actions_templ>`.

|sched_actions|

- **Display quotas in Clod View**, the end-user can see his quotas in real time.
- **Turkish language (TR)**, now in Sunstone.
- **Icons makeover**, Font Awesome has been updated to lastest version!.


vCenter
--------------------------------------------------------------------------------

- **Multiple cluster network support**: now it is possible to import networks belonging to more than 1 cluster with a better management, also you won't see duplicated networks anymore.
- **vCenter cluster migration**: migrate your vms between vCenter clusters with OpenNebula.

Core
--------------------------------------------------------------------------------

- **Lock resources**, the user can lock resources (vms, images or networks) to prevent unintended operations.

.. |sunstone_dashboard| image:: /images/sunstone_dashboard.png
.. |sched_actions| image:: /images/sched_actions.png
