.. _uspng:

================================================================================
Platform Notes
================================================================================

This page will show you the specific considerations at the time of using an OpenNebula cloud, according to the different supported platforms.

This is the list of the individual platform components that have been through the complete `OpenNebula Quality Assurance and Certification Process <http://opennebula.org/software:testing>`__.

Certified Components Version
================================================================================

Front-End Components
--------------------------------------------------------------------------------

+-------------------------+---------------------------------------------------------+-------------------------------------------------------+
|        Component        |                         Version                         |                    More information                   |
+=========================+=========================================================+=======================================================+
| RedHat Enterprise Linux | 7                                                       | :ref:`Front-End Installation <frontend_installation>` |
+-------------------------+---------------------------------------------------------+-------------------------------------------------------+
| Ubuntu Server           | 14.04 (LTS), 16.04 (LTS), 17.10                         | :ref:`Front-End Installation <frontend_installation>` |
+-------------------------+---------------------------------------------------------+-------------------------------------------------------+
| CentOS                  | 7                                                       | :ref:`Front-End Installation <frontend_installation>` |
+-------------------------+---------------------------------------------------------+-------------------------------------------------------+
| Debian                  | 8, 9                                                    | :ref:`Front-End Installation <frontend_installation>` |
+-------------------------+---------------------------------------------------------+-------------------------------------------------------+
| MariaDB or MySQL        | Version included in the Linux distribution              | :ref:`MySQL Setup <mysql>`                            |
+-------------------------+---------------------------------------------------------+-------------------------------------------------------+
| SQLite                  | Version included in the Linux distribution              | Default DB, no configuration needed                   |
+-------------------------+---------------------------------------------------------+-------------------------------------------------------+
| Ruby Gems               | Versions installed by packages and install_gems utility | :ref:`front-end installation <ruby_runtime>`          |
+-------------------------+---------------------------------------------------------+-------------------------------------------------------+
| Corosync+Pacemaker      | Version included in the Linux distribution              | :ref:`Front-end HA Setup <oneha>`                     |
+-------------------------+---------------------------------------------------------+-------------------------------------------------------+

vCenter Nodes
--------------------------------------------------------------------------------

+-----------+---------------------------------------+-------------------------------------------------+
| Component |                Version                |                 More information                |
+===========+=======================================+=================================================+
| vCenter   | 5.5/6.0/6.5, managing ESX 5.5/6.0/6.5 | :ref:`vCenter Node Installation <vcenter_node>` |
+-----------+---------------------------------------+-------------------------------------------------+

KVM Nodes
--------------------------------------------------------------------------------

+-------------------------+-----------------------------------------------------------+-----------------------------------------+
|        Component        |                          Version                          |             More information            |
+=========================+===========================================================+=========================================+
| RedHat Enterprise Linux | 7                                                         | :ref:`KVM Driver <kvmg>`                |
+-------------------------+-----------------------------------------------------------+-----------------------------------------+
| Ubuntu Server           | 14.04 (LTS) , 16.04 (LTS)                                 | :ref:`KVM Driver <kvmg>`                |
+-------------------------+-----------------------------------------------------------+-----------------------------------------+
| CentOS/RHEL             | 7                                                         | :ref:`KVM Driver <kvmg>`                |
+-------------------------+-----------------------------------------------------------+-----------------------------------------+
| Debian                  | 8, 9                                                      | :ref:`KVM Driver <kvmg>`                |
+-------------------------+-----------------------------------------------------------+-----------------------------------------+
| KVM/Libvirt             | Support for version included in the Linux distribution.   | :ref:`KVM Node Installation <kvm_node>` |
|                         | For CentOS/RedHat the packages from ``qemu-ev`` are used. |                                         |
+-------------------------+-----------------------------------------------------------+-----------------------------------------+

Open Cloud Networking Infrastructure
--------------------------------------------------------------------------------

+------------------------------+--------------------------------------------+-----------------------------------+
|         Component            |                  Version                   |          More information         |
+==============================+============================================+===================================+
| ebtables                     | Version included in the Linux distribution | :ref:`Ebtables <ebtables>`        |
+------------------------------+--------------------------------------------+-----------------------------------+
| 8021q kernel module          | Version included in the Linux distribution | :ref:`802.1Q VLAN <hm-vlan>`      |
+------------------------------+--------------------------------------------+-----------------------------------+
| Open vSwitch                 | Version included in the Linux distribution | :ref:`Open vSwitch <openvswitch>` |
+------------------------------+--------------------------------------------+-----------------------------------+
| iproute2                     | Version included in the Linux distribution | :ref:`VXLAN <vxlan>`              |
+------------------------------+--------------------------------------------+-----------------------------------+

Open Cloud Storage Infrastructure
--------------------------------------------------------------------------------

+-----------+--------------------------------------------+-------------------------------------+
| Component |                  Version                   |           More information          |
+===========+============================================+=====================================+
| iSCSI     | Version included in the Linux distribution | :ref:`LVM Drivers <lvm_drivers>`    |
+-----------+--------------------------------------------+-------------------------------------+
| LVM2      | Version included in the Linux distribution | :ref:`LVM Drivers <lvm_drivers>`    |
+-----------+--------------------------------------------+-------------------------------------+
| Ceph      | Jewel v10.2, Luminous v12.2                | :ref:`The Ceph Datastore <ceph_ds>` |
+-----------+--------------------------------------------+-------------------------------------+

Authentication
--------------------------------------------------------------------------------

+------------------------------+--------------------------------------------+----------------------------------------+
|             Component        |                  Version                   |            More information            |
+==============================+============================================+========================================+
| net-ldap ruby library        | 0.12.1                                     | :ref:`LDAP Authentication <ldap>`      |
+------------------------------+--------------------------------------------+----------------------------------------+
| openssl                      | Version included in the Linux distribution | :ref:`x509 Authentication <x509_auth>` |
+------------------------------+--------------------------------------------+----------------------------------------+

Cloud Bursting
--------------------------------------------------------------------------------

+-----------+---------+---------------------------------+
| Component | Version |         More information        |
+===========+=========+=================================+
| aws-sdk   | 2.5.10  | :ref:`Amazon EC2 Driver <ec2g>` |
+-----------+---------+---------------------------------+
| azure     | 0.7.9   | :ref:`Azure Driver <azg>`       |
+-----------+---------+---------------------------------+

.. note:: Generally for all Linux platforms, it is worth noting that gems should be installed with the :ref:`install_gems <ruby_runtime>`, avoiding the platform's package version.

Frontend Platform Notes
================================================================================

The following applies to all Front-Ends:

* XML-RPC tuning parameters (``MAX_CONN``, ``MAX_CONN_BACKLOG``, ``KEEPALIVE_TIMEOUT``, ``KEEPALIVE_MAX_CONN`` and ``TIMEOUT``) are only available with packages distributed by us as they are compiled with a newer xmlrpc-c library.
* For **cloud bursting**, a newer nokogiri gem than the one packed by current distros is required. If you are planning to use cloud bursting, you need to install nokogiri >= 1.4.4 prior to run ``install_gems``: ``# sudo gem install nokogiri -v 1.4.4``.
* Only **ruby versions >= 1.9.3 are supported**.

Ubuntu 14.04 Platform Notes
--------------------------------------------------------------------------------

Package ruby-ox shouldn't be installed as it contains a version of the gem incompatible with the CLI

CentOS 7.0 Platform Notes
--------------------------------------------------------------------------------

This distribution lacks some packaged ruby libraries. This makes some components unusable until they are installed. In the front-end, just after package installation these commands should be executed as root to install extra dependencies:

.. code::

    # /usr/share/one/install_gems

When using Apache to serve Sunstone, it is required that you disable or comment the ``PrivateTMP=yes`` directive in ``/usr/lib/systemd/system/httpd.service``.

There is an automatic job that removes all data from ``/var/tmp/``, in order to disable this, please edit the ``/usr/lib/tmpfiles.d/tmp.conf`` and remove the line that removes ``/var/tmp``.

There is a bug in libvirt that the prevents the use of the save/restore mechanism if ``cpu_model`` is set to ``'host-passthrough'`` via ``RAW``. The `work around if needed is described in this issue <http://dev.opennebula.org/issues/4204>`__.

Debian 8
--------------------------------------------------------------------------------

Make sure that the packages ``ruby-treetop`` and ``treetop`` are not installed before running ``ìnstall_gems``, as the version of ``treetop`` that comes packaged in Debian 8 is incompatible with OpenNebula. **OneFlow** requires a version >= 1.6.3 for treetop, packages distributed with Debian 8 includes an older version (1.4.5).


Nodes Platform Notes
================================================================================

The following items apply to all distributions:

* Since OpenNebula 4.14 there is a new monitoring probe that gets information about PCI devices. By default it retrieves all the PCI devices in a host. To limit the PCI devices that it gets info and appear in ``onehost show`` refer to :ref:`kvm_pci_passthrough`.
* When using qcow2 storage drivers you can make sure that the data is written to disk when doing snapshots setting its ``cache`` parameter to ``writethrough``. This change will make writes slower than other cache modes but safer. To do this edit the file ``/etc/one/vmm_exec/vmm_exec_kvm.conf`` and change the line for ``DISK``:

.. code::

    DISK = [ driver = "qcow2", cache = "writethrough" ]

CentOS/RedHat 7.0 Platform Notes
--------------------------------------------------------------------------------

Ruby Dependencies
~~~~~~~~~~~~~~~~~

In order to install ruby dependencies, the Server Optional channel needs to be enabled. Please refer to `RedHat documentation <https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/>`__ to enable the channel.

Alternatively, use CentOS 7 repositories to install ruby dependencies.

Libvirt Version
~~~~~~~~~~~~~~~

The libvirt/qemu packages used in the testing infrastructure are the ones in the ``qemu-ev`` repository. To add this repository you can install the following packages:

.. prompt:: bash # auto

    # yum install centos-release-qemu-ev
    # yum install qemu-kvm-ev

Disable PolicyKit for Libvirt
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

It is recommended that you disable PolicyKit for Libvirt:

.. prompt:: bash # auto

  $ cat /etc/libvirt/libvirtd.conf
  ...
  auth_unix_ro = "none"
  auth_unix_rw = "none"
  unix_sock_group = "oneadmin"
  unix_sock_ro_perms = "0770"
  unix_sock_rw_perms = "0770"
  ...


Unsupported Platforms Notes
================================================================================

.. warning:: Use the following distributions at your own risk. They are not officially supported by OpenNebula.

CentOS 6.5 Usage Platform Notes
--------------------------------------------------------------------------------

* As a front-end, because home directory of oneadmin is located in /var, it violates SELinux default policy. So in ssh passwordless configuration you should disable SELinux by setting SELINUX=disabled in /etc/selinux/config.

* As a node, to accomplish disk hotplugging:

  * to accomplish disk hotplugging, disks need to be attached through SCSI, so their images should have a DEV_PREFIX=“sd”
  * to accomplish disk hotplugging, VM template that will permit SCSI disk attaches afterwards needs to have an explicitly defined SCSI controller:

.. code::

     RAW=[TYPE = "kvm",
          DATA = "<devices><controller type='scsi' index='0' model='virtio-scsi'></controller></devices>"]

   * due to libvirt version < = 0.10.2, there is a bug in libvirt/qemu attach/detach nic functionality that prevents the reuse of net IDs. This means that after a successful attach/detach NIC, a new attach will fail.

Installing on ArchLinux
--------------------------------------------------------------------------------

OpenNebula is available at the Arch User Repository (AUR), `please check the opennebula package page <https://aur.archlinux.org/packages/opennebula>`__.

Installing on Gentoo
--------------------------------------------------------------------------------

There is an ebuild contributed by Thomas Stein in the following repository:

https://github.com/himbeere/opennebula

Still, if you want to compile it manually you need to install the xmlrpc-c package with threads support, as:

.. code::

      USE="threads" emerge xmlrpc-c

Installing on Devuan
--------------------

Packages for Devuan Jessie 1.0 Beta are provided by Alberto Zuin. You can download them at:

http://downloads.opennebula.org/extra/packages/devuan/

