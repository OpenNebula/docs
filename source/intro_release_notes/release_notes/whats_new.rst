.. _whats_new:

================================================================================
What's New in 5.6
================================================================================

OpenNebula 5.6 (Blue Flash) is the fourth major release of the OpenNebula 5 series. A significant effort has been applied in this release to enhance features introduced in 5.4 Medusa, while keeping an eye in implementing those features more demanded by the community. A massive set of improvements happened at the core level to increase robustness and scalability, and a major refactor happened in the vCenter integration, particularly in the import process, which has been streamlined.  Virtually every component of OpenNebula has been reviewed to target usability and functional improvements, trying to keep API changes to a minimum to avoid disrupting ecosystem components. 

In this release several development efforts have been invested in making OpenNebula even better for large scale deployments. This improvements includes both, changes in OpenNebula core to better handle concurrency as well as refined interfaces. Sunstone dashboard has been redesigned to provided sensible information in a more responsive way. Sunstone also features some new styling touches here and there, and it has been updated to version 5 of Fontawesome.

|sunstone_dashboard|

Blue Flash also includes several quality of life improvements for end-users. In particular, it is now possible to schedule periodic actions on VMs. Want to shutdown your VM every Friday at 5p.m. and start it on Monday 7p.m. just before work... We got you covered. Also, don't to want accidentally terminate that important VM or want to freeze a Network; now you can set locks on common resources to prevent actions to be performed on them.

|sched_actions|

5.6. ends the major redesign on the vCenter driver started in 5.4. The new integration with vCenter features stability and performance improvements, as well as important new features like a extended multicluster support or a redesigned importation workflow with new Sunstone tabs as well as a new CLI. 

Following our tradition this OpenNebula release is named after NGC 6905, also known as the :ref:`Blue Flash Nebula <https://en.wikipedia.org/wiki/NGC_6905>`, a planetary nebula in the constellation Delphinus. It was discovered by William Herschel in 1784.

The OpenNebula team is now set to bug-fixing mode. Note that this is a beta release aimed at testers and developers to try the new features, and send a more than welcomed feedback for the final release. Note that being a beta there is no migration path from the previous stable version (5.4.13) nor migration path to the final stable version (5.4.0).

In the following list you can check the highlights of OpenNebula 5.6 (a detailed list of changes can be found :ref:`here <https://github.com/OpenNebula/one/milestone/4?closed=1>`):

OpenNebula Core
--------------------------------------------------------------------------------
.. - **New HA model**, providing native HA (based on RAFT consensus algorithm) in OpenNebula components, including Sunstone without :ref:`third party dependencies <frontend_ha_setup>`.

- **Program Periodic VM actions**, the user can schedule periodic actions to be performed regularly in a VM.
- **Lock resources**, the user can lock resources (VMs, images or networks) to prevent unintended operations.
- **Create as uid/gid**: Users can define the final owner and/or group for a VM when creating it. :ref:`See more information here <instantiate_as_uid_gid>`.
- **Improved Monitoring**: several synchronization points have been removed from one to improve concurrency in the monitoring process. Also database connections are now configurable to allow more parallel access to the database.
- **Default permission for VDC ACLs**: Administrator can specify the default permission for the automatic ACLs created when a resource is added to a VDC. :ref:`oned.conf <oned_conf>`.
- **More IO throttling attributes**: We have added more attribute to define IO throttling support into disk section. :ref:`See more information here <reference_vm_template_disk_section>`.
- **Minor Raft enhancements**: It includes a better purge algorithm, improved timeout control as well as extended information to check out the health of the cluster.
- **Support to set CPU model**: The CPU model can be now set. Available modes are obtained through monitor, and stored in the hosts.
- **API request logs**: Log format supports a configurable number of characters for API call parameters.

Storage
--------------------------------------------------------------------------------
- **Deploy the images wherever you want**: We have added the possibility to select different deployment modes for Image datastores. For example the same Ceph Image can be used directly from the pool (default ceph mode) or run from the hypervisor local storage (ssh mode). :ref:`More info. <ceph_ds>`. Also shared Filesystem datastores can be combined with the host local storage (ssh mode). :ref:`More info.<fs_ds>`

Networking
--------------------------------------------------------------------------------
- Better support for security group rules with a large number of ports. :ref:`See configuration options here <bridged_conf>`.
- **Open vSwitch** rules for the ARP/MAC/IP spoofing filters were refactored.
- New **Open vSwitch on VXLAN** driver. Driver :ref:`ovswitch_vxlan <openvswitch_vxlan>`.
- New **Bridged drvier** that supports managed Linux bridges :ref:`more info <bridged>`.

Authentication
--------------------------------------------------------------------------------
- **Server Groups for LDAP driver**, when configuring your LDAP driver you can define *availability groups* to reduce the number of authentication requests sent to the LDAP servers, :ref:`more info <ldap_configuration>`.

Hybrid Clouds
--------------------------------------------------------------------------------
- **One to One**, the users will can deploying VMs on a remote OpenNebula from local OpenNebula. :ref:`Driver one-to-one <oneg>`.

Scheduler
--------------------------------------------------------------------------------
- **Memory system datastore scale**, This factor scales the VM usage of the system DS with the memory size. :ref:`Scheduler configuration <schg_configuration>`.

Sunstone
--------------------------------------------------------------------------------

- **New dashboard**, intuitive, fast and light. The new dashboard will perform better on large deployments.
- **KVM and vCenter more united than ever**, a single view to control the two hypervisors. :ref:`Completely customizable views <suns_views>`.
- **Scheduled Actions** can now be defined in VM Template create and instantiate dialogs. :ref:`More info <sched_actions_templ>`.
- **New global configurations**. To be able to customize Sunstone even more, :ref:`there are new features in the yamls <suns_views_custom>`.
- **Disk resize in the cloud view**. Now you can resize a disk as a user cloud.
- **Quotas in cloud view**. Quotas are shown in Cloud view, and marked red when exceeded.
- **Display quotas in Clod View**, the end-user can see his quotas in real time.
- **Turkish language (TR)**, now in Sunstone.
- **Icons makeover**, Font Awesome has been updated to lastest version!.
- **Timeout option for xmlrpc calls**, you can add this new option inside :ref:`sunstone-server.conf <sunstone_setup>`, now it's possible to configure the timeout of OpenNebula XMLRPC for all operations from sunstone.


vCenter
--------------------------------------------------------------------------------
- **Multiple cluster network support**: now it is possible to import networks belonging to more than 1 cluster with a better management, also you won't see duplicated networks anymore.
- **vCenter cluster migration**: migrate your vms between vCenter clusters with OpenNebula.
- **vCenter Marketplace**: now it's available the HTTP and S3 Marketplaces for vCenter datastores.

API & CLI
--------------------------------------------------------------------------------
- **zone show**: users can view all information of HA servers with the option `-x`. The Zone::info_extended() method exposes this functionality to be used by other tools (only in Ruby OCA).


.. |sunstone_dashboard| image:: /images/sunstone_dashboard.png
.. |sched_actions| image:: /images/sched_actions.png
