.. _upgrade_62:

================================================================================
Upgrading Front-end Deployments from 6.2.x
================================================================================

If you are upgrading from a 6.2.x installation you only need to follow a reduced set of steps. If you are running a 6.0.x version or older, please check :ref:`these set of steps <upgrade_single>` (some additional ones may apply, please review them at the end of the section).

.. important:: Users of the Community Edition of OpenNebula can upgrade from the previous stable version if they are running a non-commercial OpenNebula cloud. In order to access the migrator package a request needs to be made through this `online form <https://opennebula.io/get-migration>`__.

This section describes the installation procedure for systems that are already running a 6.2.x OpenNebula. The upgrade to OpenNebula |version| can be done directly following this section, you don't need to perform intermediate version upgrades. The upgrade will preserve all current users, hosts, resources and configurations.

When performing a minor upgrade OpenNebula adheres to the following convention to ease the process:

    * No changes are made to the configuration files, so no configuration file will be changed during the upgrade.
    * Database versions are preserved, so no upgrade of the database schema is needed.

When a critical bug requires an exception to the previous rules it will be explicitly noted in this guide.

Single Front-end
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Step 1. Check Virtual Machine Status
================================================================================

Before proceeding, make sure you don't have any VMs in a transient state (prolog, migrate, epilog, save). Wait until these VMs get to a final state (running, suspended, stopped, done). Check the :ref:`Managing Virtual Machines guide <vm_guide_2>` for more information on the VM life-cycle.

Step 2. Set All Hosts to Disable Mode
================================================================================

Set all Hosts to disable mode to stop all monitoring processes.

.. prompt:: bash $ auto

   $ onehost disable <host_id>

Use ``onezone disable <zone_id>`` to make sure that no operation changing OpenNebula state are executed.

Step 3. Stop OpenNebula
================================================================================

Stop OpenNebula and any other related services you may have running: OneFlow, OneGate, Sunstone & FireEdge. It's preferable to use the system tools, like ``systemctl`` or ``service`` as ``root`` in order to stop the services.

.. important:: If you are running Sunstone behind Apache/Nginx, please stop this service instead of Sunstone one.

.. warning:: Make sure that every OpenNebula process is stopped. The output of ``systemctl list-units | grep opennebula`` should be empty.

Step 4. Upgrade to the New Version
================================================================================

Ubuntu/Debian

.. prompt:: bash $ auto

    $ apt-get update
    $ apt-get install --only-upgrade opennebula opennebula-sunstone opennebula-gate opennebula-flow opennebula-provision opennebula-fireedge python3-pyone

RHEL

.. prompt:: bash $ auto

    $ yum upgrade opennebula opennebula-sunstone opennebula-gate opennebula-flow opennebula-provision pennebula-fireedge python3-pyone

Step 5. Start OpenNebula
================================================================================

Start OpenNebula and any other related services: OneFlow, OneGate, Sunstone & FireEdge. It's preferable to use the system tools, like ``systemctl`` or ``service`` as ``root`` in order to stop the services.

.. important:: If you are running Sunstone behind Apache/Nginx, please start this service instead of Sunstone one.

Step 6. Update the Hypervisors
================================================================================

.. warning:: If you're using vCenter please skip to the next step.

Update the virtualization, storage and networking drivers.  As the ``oneadmin`` user, execute:

.. prompt:: bash $ auto

   $ onehost sync

Then log in to your hypervisor Hosts and update the ``opennebula-node`` packages:

Ubuntu/Debian

.. prompt:: bash $ auto

    $ apt-get install --only-upgrade opennebula-node-<hypervisor>

RHEL

.. prompt:: bash $ auto

    $ yum upgrade opennebula-node-<hypervisor>

.. note:: Note that the ``<hypervisor>`` tag should be replaced by the name of the corresponding hypervisor (i.e ``kvm``, ``lxc`` or ``firecracker``).

.. important::  For KVM hypervisor it's necessary to restart also the libvirt service

Step 7. Enable Hosts
================================================================================

Enable all Hosts, disabled in step 2:

.. prompt:: bash $ auto

   $ onehost enable <host_id>

Use ``onezone enable <zone_id>`` to make OpenNebula fully functional.

High Availability
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The important thing is the order when upgrading the servers to avoid downtime, you need to start performing steps 1-7 in the current **leader**, so there is a new election process to have a new leader.

After that, continue with the current leader, until you finish upgrading all the servers.

Federation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There is no special step to perform, you can follow steps 1-7 in all your master and slaves zones.

.. note:: When upgrading the master, slaves won't be able to write on federated tables, because this action can be **only** performed by the master.

Testing
================================================================================

OpenNebula will continue the monitoring and management of your previous Hosts and VMs.

As a measure of caution, look for any error messages in ``/var/log/one/oned.log``, and check that all drivers are loaded successfully. You may also try some  **show** subcommand for some resources to check everything is working (e.g. ``onehost show``, or ``onevm show``).

Restoring the Previous Version
================================================================================

If for any reason you need to restore your previous OpenNebula, simply uninstall OpenNebula |version|, and install again your previous version. After that, update the drivers if needed, as outlined in Step 8.
