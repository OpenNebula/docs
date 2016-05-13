.. _uspng:

================================================================================
Platform Notes
================================================================================

This page will show you the specific considerations at the time of using an OpenNebula cloud, according to the different supported platforms.

This is the list of the individual platform components that have been through the complete `OpenNebula Quality Assurance and Certification Process <http://opennebula.org/software:testing>`__.

.. todo::

   complete versions for

     - corosync+pacemaker
     - ebtables
     - vlan
     - openvswitch
     - iproute2
     - iscsi ?? needed?
     - lvm2
     - ldap
     - x509 (openssl needed?)


Front-End Components
================================================================================

+------------------------------+---------------------------------------------------------+-------------------------------------------------------+
| Certified Platform Component |                         Version                         |                    More information                   |
+==============================+=========================================================+=======================================================+
| RedHat Enterprise Linux      | 7.0                                                     | :ref:`Front-End Installation <frontend_installation>` |
+------------------------------+---------------------------------------------------------+-------------------------------------------------------+
| Ubuntu Server                | 14.04 (LTS) , 16.04                                     | :ref:`Front-End Installation <frontend_installation>` |
+------------------------------+---------------------------------------------------------+-------------------------------------------------------+
| CentOS                       | 7.0                                                     | :ref:`Front-End Installation <frontend_installation>` |
+------------------------------+---------------------------------------------------------+-------------------------------------------------------+
| Debian                       | 8                                                       | :ref:`Front-End Installation <frontend_installation>` |
+------------------------------+---------------------------------------------------------+-------------------------------------------------------+
| MySQL                        | Version included in the Linux distribution              | :ref:`MySQL Setup <mysql>`                            |
+------------------------------+---------------------------------------------------------+-------------------------------------------------------+
| sqlite                       | Version included in the Linux distribution              | Default DB, no configuration needed                   |
+------------------------------+---------------------------------------------------------+-------------------------------------------------------+
| Ruby Gems                    | Versions installed by packages and install_gems utility | :ref:`front-end installation <ruby_runtime>`          |
+------------------------------+---------------------------------------------------------+-------------------------------------------------------+
| Corosync+Pacemaker           |                                                         | :ref:`Front-end HA Setup <oneha>`                     |
+------------------------------+---------------------------------------------------------+-------------------------------------------------------+

vCenter Nodes
================================================================================

+------------------------------+---------+-----------------------------------------------------------------------+
| Certified Platform Component | Version |                            More information                           |
+==============================+=========+=======================================================================+
| vCenter                      | 5.5/6.0 | Managing ESX 5.5/5.0. :ref:`vCenter Node Installation <vcenter_node>` |
+------------------------------+---------+-----------------------------------------------------------------------+

KVM Nodes
================================================================================

+------------------------------+-----------------------------------------------------------------------+-------------------------------------------------------+
| Certified Platform Component |                                Version                                |                    More information                   |
+==============================+=======================================================================+=======================================================+
| RedHat Enterprise Linux      | 7.0                                                                   | :ref:`Front-End Installation <frontend_installation>` |
+------------------------------+-----------------------------------------------------------------------+-------------------------------------------------------+
| Ubuntu Server                | 14.04 (LTS) , 16.04                                                   | :ref:`Front-End Installation <frontend_installation>` |
+------------------------------+-----------------------------------------------------------------------+-------------------------------------------------------+
| CentOS                       | 7.0                                                                   | :ref:`Front-End Installation <frontend_installation>` |
+------------------------------+-----------------------------------------------------------------------+-------------------------------------------------------+
| Debian                       | 8                                                                     | :ref:`Front-End Installation <frontend_installation>` |
+------------------------------+-----------------------------------------------------------------------+-------------------------------------------------------+
| KVM/Libvirt                  | Support for version included in the kernel for the Linux distribution | :ref:`KVM Node Installation <kvm_node>`               |
+------------------------------+-----------------------------------------------------------------------+-------------------------------------------------------+

Open Cloud Networking Infrastructure
================================================================================

+------------------------------+---------+-----------------------------------+
| Certified Platform Component | Version |          More information         |
+==============================+=========+===================================+
| ebtables                     |         | :ref:`Ebtables <ebtables>`        |
+------------------------------+---------+-----------------------------------+
| 8021q kernel module          |         | :ref:`802.1Q VLAN <hm-vlan>`      |
+------------------------------+---------+-----------------------------------+
| Open vSwitch                 |         | :ref:`Open vSwitch <openvswitch>` |
+------------------------------+---------+-----------------------------------+
| iproute2                     |         | :ref:`VXLAN <vxlan>`              |
+------------------------------+---------+-----------------------------------+

Open Cloud Storage Infrastructure
================================================================================

+------------------------------+--------------------+---------------------------------------+
| Certified Platform Component |      Version       |            More information           |
+==============================+====================+=======================================+
| iSCSI                        |                    | :ref:`The iSCSI Datastore <iscsi_ds>` |
+------------------------------+--------------------+---------------------------------------+
| LVM2                         |                    | :ref:`LVM Drivers <lvm_drivers>`      |
+------------------------------+--------------------+---------------------------------------+
| Ceph                         | Hammer (LTS) v0.94 | :ref:`The Ceph Datastore <ceph_ds>`   |
+------------------------------+--------------------+---------------------------------------+

Authentication
================================================================================

+------------------------------+---------+----------------------------------------+
| Certified Platform Component | Version |            More information            |
+==============================+=========+========================================+
| LDAP                         |         | :ref:`LDAP Authentication <ldap>`      |
+------------------------------+---------+----------------------------------------+
| openssl                      |         | :ref:`x509 Authentication <x509_auth>` |
+------------------------------+---------+----------------------------------------+

Cloud Bursting
================================================================================

+------------------------------+---------+---------------------------------+
| Certified Platform Component | Version |         More information        |
+==============================+=========+=================================+
| aws-sdk                      | 1.66    | :ref:`Amazon EC2 Driver <ec2g>` |
+------------------------------+---------+---------------------------------+
| azure                        | 0.6.4   | :ref:`Azure Driver <azg>`       |
+------------------------------+---------+---------------------------------+

.. note:: Generally for all Linux platforms, it is worth noting that gems should be installed with the :ref:`install_gems <ruby_runtime>`, avoiding the platform's package version.

Specific Platform Notes
================================================================================

The following applies to all Front-Ends:

-  xmlrpc tuning parameters (MAX\_CONN, MAX\_CONN\_BACKLOG, KEEPALIVE\_TIMEOUT, KEEPALIVE\_MAX\_CONN and TIMEOUT) are only available with packages distributed by us as they are compiled with a newer xmlrpc-c library.

-  for **cloud bursting**, a newer nokogiri gem than the one packed by current distros is required. If you are planning to use cloud bursting, you need to install nokogiri >= 1.4.4 prior to run ``install_gems``

.. code::

    # sudo gem install nokogiri -v 1.4.4

- older ruby versions ( <= 1.9.3 ) are not supported for **cloud bursting** (specifically for Microsoft Azur) and the :ref:`Sunstone commercial support integration <commercial_support_sunstone>`.

- **OneFlow** requires a version >= 1.6.3 for treetop, packages distributed with Debian 8 includes an older version (1.4.5) and must be removed

CentOS 7.0 Platform Notes
--------------------------------------------------------------------------------

This distribution lacks some packaged ruby libraries. This makes some components unusable until they are installed. In the frontend, just after package installation these commands should be executed as root to install extra dependencies:

.. code::

    # /usr/share/one/install_gems

When using Apache to serve Sunstone, it is required that you disable or comment the ``PrivateTMP=yes`` directive in ``/usr/lib/systemd/system/httpd.service``.

There is an automatic job that removes all data from ``/var/tmp/``, in order to disable this, please edit the ``/usr/lib/tmpfiles.d/tmp.conf`` and re ove the line that removes ``/var/tmp``.

Ubuntu 14.04 Platform Notes
--------------------------------------------------------------------------------

Package ruby-ox shouldn't be installed as it cointains a version of the gem incompatible with the CLI

RedHat 7.0 Platform Notes
--------------------------------------------------------------------------------

In order to install ruby dependencies, the Server Optional channel needs to be enabled. Please refer to `RedHat documentation <https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/>`__ to enable the channel.

Alternatively, use CentOS 7 repositories to install ruby dependencies.

Nodes Platform Notes
--------------------------------------------------------------------------------

-  Since OpenNebula 4.14 there is a new monitoring probe that gets information about PCI devices. By default it retrieves all the PCI devices in a host. To limit the PCI devices that it gets info and appear in ``onehost show`` refer to :ref:`kvm_pci_passthrough`.
-  When using qcow2 storage drivers you can make sure that the data is written to disk when doing snapshots setting its ``cache`` parameter to ``writethrough``. This change will make writes slower than other cache modes but safer. To do this edit the file ``/etc/one/vmm_exec/vmm_exec_kvm.conf`` and change the line for ``DISK``:

.. code::

    DISK     = [ driver = "qcow2", cache = "writethrough" ]

Debian 8
--------------------------------------------------------------------------------

Make sure that the packages ``ruby-treetop`` and ``treetop`` are not installed before running ``ìnstall_gems``. The version of ``treetop`` that comes packaged in debian is incompatible with OpenNebula.

Unsupported Platforms Notes
--------------------------------------------------------------------------------

CentOS 6.5 Usage Platform Notes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* As a front-end, because home directory of oneadmin is located in /var, it violates SELinux default policy. So in ssh passwordless configuration you should disable SELinux by setting SELINUX=disabled in /etc/selinux/config.

* As a node, to accomplish disk hotplugging:

  * to accomplish disk hotplugging, disks need to be attached through SCSI, so their images should have a DEV_PREFIX=“sd” 
  * to accomplish disk hotplugging, VM template that will permit SCSI disk attaches afterwards needs to have an explicitly defined SCSI controller:

.. code::

     RAW=[TYPE = "kvm",
          DATA = "<devices><controller type='scsi' index='0' model='virtio-scsi'></controller></devices>"]

   * due to libvirt version < = 0.10.2, there is a bug in libvrit/qemu attac/detach nic functionality that prevents the reuse of net IDs. This means that after a successful attach/detach NIC, a new attach will fail.

Installing on ArchLinux
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

OpenNebula is available at the Arch User Repository (AUR), `please check the opennebula package page <https://aur.archlinux.org/packages.php?ID=32163>`__.

Installing on Gentoo
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There is an ebuild contributed by Thomas Stein in the following repository:

https://github.com/himbeere/opennebula

Still, if you want to compile it manually you need to install the xmlrpc-c package with threads support, as:

.. code::

      USE="threads" emerge xmlrpc-c

