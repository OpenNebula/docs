.. _upgrade_512:

=================================
Upgrading from OpenNebula 5.12.x
=================================

This section describes the installation procedure for systems that are already running a 5.12.x OpenNebula. The upgrade to OpenNebula |version| can be done directly following this section, you don't need to perform intermediate version upgrades. The upgrade will preserve all current users, hosts, resources and configurations; for both Sqlite and MySQL backends.

When performing a minor upgrade OpenNebula adheres to the following convention to ease the process:

  * No changes are made to the configuration files, so no configuration file will be changed during the upgrade.
  * Database versions are preserved, so no upgrade of the database schema is needed.

When a critical bug requires an exception to the previous rules it will be explicitly noted in this guide.

Upgrading a Federation and High Availability
================================================================================

You need to perform the following steps in all the HA nodes and all zones. You can upgrade the servers one by one to not incur in any downtime.

Step 1 Stop OpenNebula services
===============================

Before proceeding, make sure you don't have any VMs in a transient state (prolog, migr, epil, save). Wait until these VMs get to a final state (runn, suspended, stopped, done). Check the :ref:`Managing Virtual Machines guide <vm_guide_2>` for more information on the VM life-cycle.

Now you are ready to stop OpenNebula and any other related services you may have running, e.g. Sunstone or OneFlow. Use preferably the system tools, like `systemctl` or `service` as `root` in order to stop the services.

Step 2 Upgrade frontend to the new version
==========================================

Upgrade the OpenNebula software using the package manager of your OS. Refer to the :ref:`Installation guide <ignc>` for a complete list of the OpenNebula packages installed in your system. Package repos need to be pointing to the latest version (|version|).

For example, in a rpm based Linux distribution simply execute:

.. prompt:: bash

   yum update opennebula

For deb based distros use:

.. prompt:: bash

   apt-get update
   apt-get install opennebula

Step 3 Reload start scripts
================================

Follow this section if you are using a `systemd` base distribution, like CentOS 7+, Ubuntu 16.04+, etc.

In order for the system to re-read the configuration files you should issue the following command after the installation of the new packages:

.. prompt:: text # auto

    # systemctl daemon-reload

Step 4 Upgrade hypervisors to the new version
=============================================

You can skip this section for vCenter hosts.

Upgrade the OpenNebula node KVM or LXD packages, using the package manager of your OS.

For example, in a rpm based Linux distribution simply execute:

.. prompt:: bash

   yum update opennebula-node-kvm

For deb based distros use:

.. prompt:: bash

   apt-get update
   apt-get install opennebula-node-kvm

.. note:: If you are using LXD the package is opennebula-node-lxd

Update the Drivers
==================

You should be able now to start OpenNebula as usual, running ``service opennebula start`` as ``root``. At this point, as ``oneadmin`` user, execute ``onehost sync`` to update the new drivers in the hosts.

.. note:: You can skip this step if you are not using KVM hosts, or any hosts that use remove monitoring probes.

Testing
=======

OpenNebula will continue the monitoring and management of your previous Hosts and VMs.

As a measure of caution, look for any error messages in oned.log, and check that all drivers are loaded successfully. After that, keep an eye on oned.log while you issue the onevm, onevnet, oneimage, oneuser, onehost **list** commands. Try also using the **show** subcommand for some resources.

Restoring the Previous Version
==============================

If for any reason you need to restore your previous OpenNebula, simply uninstall OpenNebula |version|, and install again your previous version. After that, update the drivers as described above.
