===============================
Upgrading from OpenNebula 4.6.1
===============================

This guide describes the installation procedure for systems that are already running an OpenNebula 4.6.1. The upgrade will preserve all current users, hosts, resources and configurations; for both Sqlite and MySQL backends.

`This is the list of issues <http://dev.opennebula.org/projects/opennebula/issues?query_id=54>`__ resolved in OpenNebula 4.6.2.

Preparation
===========

Before proceeding, make sure you don't have any VMs in a transient state (prolog, migr, epil, save). Wait until these VMs get to a final state (runn, suspended, stopped, done). Check the :ref:`Managing Virtual Machines guide <vm_guide_2>` for more information on the VM life-cycle.

Stop OpenNebula and any other related services you may have running: EC2, OCCI, and Sunstone. As ``oneadmin``, in the front-end:

.. code::

    $ sunstone-server stop
    $ oneflow-server stop
    $ econe-server stop
    $ occi-server stop
    $ one stop

Backup
======

In this version the configuration files have not changed at all from 4.6.1.

Installation
============

Follow the :ref:`Platform Notes <uspng>` and the :ref:`Installation guide <ignc>`, taking into account that you will already have configured the passwordless ssh access for oneadmin.

There has been no changes in the ``oned.conf`` file from OpenNebula 4.6.0, therefore you can safely continue issue the same configuration file.

Configuration Files Upgrade
===========================

If you haven't modified any configuration files, the package managers will replace the configuration files with their newer versions and no manual intervention is required.

Database Upgrade
================

No Database upgrade required

Update the Drivers
==================

You should be able now to start OpenNebula as usual, running 'one start' as oneadmin. At this point, execute ``onehost sync`` to update the new drivers in the hosts.

.. warning:: Doing ``onehost sync`` is important. If the monitorization drivers are not updated, the hosts will behave erratically.

Testing
=======

OpenNebula will continue the monitoring and management of your previous Hosts and VMs.

As a measure of caution, look for any error messages in oned.log, and check that all drivers are loaded successfully. After that, keep an eye on oned.log while you issue the onevm, onevnet, oneimage, oneuser, onehost **list** commands. Try also using the **show** subcommand for some resources.

Restoring the Previous Version
==============================

If for any reason you need to restore your previous OpenNebula, follow these steps:

-  Uninstall OpenNebula 4.6, and install again your previous version.
-  Copy back the backup of /etc/one you did to restore your configuration.

Known Issues
============

No known issues.
