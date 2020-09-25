.. _uspng:

================================================================================
Platform Notes
================================================================================

This page will show you the specific considerations at the time of using an OpenNebula cloud, according to the different supported platforms.

This is the list of the individual platform components that have been through the complete `OpenNebula Quality Assurance and Certification Process <https://github.com/OpenNebula/one/wiki/Quality-Assurance>`__.

Certified Components Version
================================================================================

Front-End Components
--------------------------------------------------------------------------------

+--------------------------+--------------------------------------------------------+-------------------------------------------------------+
|        Component         |                        Version                         |                    More information                   |
+==========================+========================================================+=======================================================+
| Red Hat Enterprise Linux | 7, 8                                                   | :ref:`Front-End Installation <frontend_installation>` |
+--------------------------+--------------------------------------------------------+-------------------------------------------------------+
| CentOS                   | 7, 8                                                   | :ref:`Front-End Installation <frontend_installation>` |
+--------------------------+--------------------------------------------------------+-------------------------------------------------------+
| Ubuntu Server            | 16.04 (LTS), 18.04 (LTS), 20.04 (LTS)                  | :ref:`Front-End Installation <frontend_installation>` |
+--------------------------+--------------------------------------------------------+-------------------------------------------------------+
| Debian                   | 9, 10                                                  | :ref:`Front-End Installation <frontend_installation>` |
+--------------------------+--------------------------------------------------------+-------------------------------------------------------+
| MariaDB or MySQL         | Version included in the Linux distribution             | :ref:`MySQL Setup <mysql>`                            |
+--------------------------+--------------------------------------------------------+-------------------------------------------------------+
| PostgreSQL               | 9.5+, Version included in the Linux distribution       | :ref:`PostgreSQL Setup <postgresql>`                  |
|                          | (except RHEL/CentOS 7)                                 |                                                       |
+--------------------------+--------------------------------------------------------+-------------------------------------------------------+
| SQLite                   | Version included in the Linux distribution             | Default DB, no configuration needed                   |
+--------------------------+--------------------------------------------------------+-------------------------------------------------------+
| Ruby Gems                | Versions installed by packages or install_gems utility | :ref:`front-end installation <ruby_runtime>`          |
+--------------------------+--------------------------------------------------------+-------------------------------------------------------+
| Corosync+Pacemaker       | Version included in the Linux distribution             | :ref:`Front-end HA Setup <oneha>`                     |
+--------------------------+--------------------------------------------------------+-------------------------------------------------------+

.. _vcenter_nodes_platform_notes:

vCenter Nodes
--------------------------------------------------------------------------------

+-----------+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------+
| Component |                Version                |                                                            More information                                                            |
+===========+=======================================+========================================================================================================================================+
| vCenter   | 6.0/6.5/6,7, managing ESX 6.0/6.5/6.7 | :ref:`vCenter Node Installation <vcenter_node>`                                                                                        |
+-----------+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------+
| NSX-T     | 2.4.1+                                | `VMware compatiblity <https://www.vmware.com/resources/compatibility/sim/interop_matrix.php>`__. :ref:`NSX Documentation <nsx_setup>`. |
+-----------+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------+
| NSX-V     | 6.4.5+                                | `VMware compatiblity <https://www.vmware.com/resources/compatibility/sim/interop_matrix.php>`__. :ref:`NSX Documentation <nsx_setup>`  |
+-----------+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------+

KVM Nodes
--------------------------------------------------------------------------------

+--------------------------+---------------------------------------------------------+-----------------------------------------+
|        Component         |                         Version                         |             More information            |
+==========================+=========================================================+=========================================+
| Red Hat Enterprise Linux | 7, 8                                                    | :ref:`KVM Driver <kvmg>`                |
+--------------------------+---------------------------------------------------------+-----------------------------------------+
| CentOS                   | 7, 8                                                    | :ref:`KVM Driver <kvmg>`                |
+--------------------------+---------------------------------------------------------+-----------------------------------------+
| Ubuntu Server            | 16.04 (LTS), 18.04 (LTS), 20.04 (LTS)                   | :ref:`KVM Driver <kvmg>`                |
+--------------------------+---------------------------------------------------------+-----------------------------------------+
| Debian                   | 9, 10                                                   | :ref:`KVM Driver <kvmg>`                |
+--------------------------+---------------------------------------------------------+-----------------------------------------+
| KVM/Libvirt              | Support for version included in the Linux distribution. | :ref:`KVM Node Installation <kvm_node>` |
|                          | For CentOS/RHEL the packages from ``qemu-ev`` are used. |                                         |
+--------------------------+---------------------------------------------------------+-----------------------------------------+

LXD Nodes
--------------------------------------------------------------------------------

+-------------------------+-----------------------------------------------------------+-----------------------------------------+
|        Component        |                          Version                          |             More information            |
+=========================+===========================================================+=========================================+
| Ubuntu Server           | 16.04 (LTS), 18.04 (LTS), 20.04 (LTS)                     | :ref:`LXD Driver <lxdmg>`               |
+-------------------------+-----------------------------------------------------------+-----------------------------------------+
| Debian                  | 10                                                        | :ref:`LXD Driver <lxdmg>`               |
+-------------------------+-----------------------------------------------------------+-----------------------------------------+
| LXD                     | Support for LXD = 3.0.x either snap or system package     | :ref:`LXD Node Installation <lxd_node>` |
+-------------------------+-----------------------------------------------------------+-----------------------------------------+

Firecracker Nodes
--------------------------------------------------------------------------------

+--------------------------+-------------------------------------------------+----------------------------------+
|        Component         |                     Version                     |         More information         |
+==========================+=================================================+==================================+
| Red Hat Enterprise Linux | 7, 8                                            | :ref:`Firecracker Driver <fcmg>` |
+--------------------------+-------------------------------------------------+----------------------------------+
| CentOS                   | 7, 8                                            | :ref:`Firecracker Driver <fcmg>` |
+--------------------------+-------------------------------------------------+----------------------------------+
| Ubuntu Server            | 16.04 (LTS), 18.04 (LTS), 20.04 (LTS)           | :ref:`Firecracker Driver <fcmg>` |
+--------------------------+-------------------------------------------------+----------------------------------+
| Debian                   | 9, 10                                           | :ref:`Firecracker Driver <fcmg>` |
+--------------------------+-------------------------------------------------+----------------------------------+
| KVM/Firecracker          | Support for KVM version included in the Linux   | :ref:`Firecracker Node           |
|                          | distribution.                                   | Installation <fc_node>`          |
|                          | For Firecracker/Jailer version v0.21.1 is used. |                                  |
+--------------------------+-------------------------------------------------+----------------------------------+

.. _context_supported_platforms:

Linux Contextualization Packages
---------------------------------------------------------------------------------

+------------------------------+-----------------------------------+------------------------------------------------------------------------------------------+
|          Component           |              Version              |                                     More information                                     |
+==============================+===================================+==========================================================================================+
| Amazon Linux                 | 2                                 | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+-----------------------------------+------------------------------------------------------------------------------------------+
| CentOS                       | 6, 7, 8, 8 Stream                 | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+-----------------------------------+------------------------------------------------------------------------------------------+
| Red Hat Enterprise Linux     | 7, 8                              | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+-----------------------------------+------------------------------------------------------------------------------------------+
| Fedora                       | 30, 31, 32                        | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+-----------------------------------+------------------------------------------------------------------------------------------+
| openSUSE                     | 15, Tumbleweed                    | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+-----------------------------------+------------------------------------------------------------------------------------------+
| SUSE Linux Enterprise Server | 12 SP3                            | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+-----------------------------------+------------------------------------------------------------------------------------------+
| ALT Linux                    | p9, Sisyphus                      | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+-----------------------------------+------------------------------------------------------------------------------------------+
| Debian                       | 8, 9, 10                          | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+-----------------------------------+------------------------------------------------------------------------------------------+
| Devuan                       | 2                                 | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+-----------------------------------+------------------------------------------------------------------------------------------+
| Ubuntu                       | 14.04, 16.04, 18.04, 19.10, 20.04 | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+-----------------------------------+------------------------------------------------------------------------------------------+
| Alpine Linux                 | 3.8, 3.9, 3.10, 3.11              | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+-----------------------------------+------------------------------------------------------------------------------------------+
| FreeBSD                      | 11, 12                            | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+-----------------------------------+------------------------------------------------------------------------------------------+

Windows Contextualization Packages
---------------------------------------------------------------------------------

+----------------+---------+----------------------------------------------------------------------------------------------+
|   Component    | Version |                                       More information                                       |
+================+=========+==============================================================================================+
| Windows        | 7+      | `Windows Contextualization Packages <https://github.com/OpenNebula/addon-context-windows>`__ |
+----------------+---------+----------------------------------------------------------------------------------------------+
| Windows Server | 2008+   | `Windows Contextualization Packages <https://github.com/OpenNebula/addon-context-windows>`__ |
+----------------+---------+----------------------------------------------------------------------------------------------+

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
| Ceph      | Jewel v10.2.x, Luminous v12.2.x,           | :ref:`The Ceph Datastore <ceph_ds>` |
|           | Mimic v13.2.x, Nautilus v14.2.x            |                                     |
+-----------+--------------------------------------------+-------------------------------------+

Authentication
--------------------------------------------------------------------------------

+------------------------------+--------------------------------------------+----------------------------------------+
|             Component        |                  Version                   |            More information            |
+==============================+============================================+========================================+
| net-ldap ruby library        | 0.12.1 or 0.16.1                           | :ref:`LDAP Authentication <ldap>`      |
+------------------------------+--------------------------------------------+----------------------------------------+
| openssl                      | Version included in the Linux distribution | :ref:`x509 Authentication <x509_auth>` |
+------------------------------+--------------------------------------------+----------------------------------------+

Cloud Bursting
--------------------------------------------------------------------------------

+-----------+----------+---------------------------------+
| Component | Version  |         More information        |
+===========+==========+=================================+
| aws-sdk   | 2.11.330 | :ref:`Amazon EC2 Driver <ec2g>` |
+-----------+----------+---------------------------------+
| azure     | 0.7.10   | :ref:`Azure Driver <azg>`       |
+-----------+----------+---------------------------------+
| one-to-one| 1.0.0    | :ref:`OpenNebula Driver <oneg>` |
+-----------+----------+---------------------------------+

Application Containerization
--------------------------------------------------------------------------------

+------------------------------+--------------------------------------------+
|             Component        |                  Version                   |
+==============================+============================================+
| Docker                       | 19.03.5 CE                                 |
+------------------------------+--------------------------------------------+
| Docker Machine               | 0.14.0                                     |
+------------------------------+--------------------------------------------+
| Appliance OS                 | Ubuntu 16.04                               |
+------------------------------+--------------------------------------------+

Sunstone
--------------------------------------------------------------------------------

+---------------------------+-----------------------------------------------------------------------------------------------+
|          Browser          |                                            Version                                            |
+===========================+===============================================================================================+
| Chrome                    | 61.0 - 85.0                                                                                   |
+---------------------------+-----------------------------------------------------------------------------------------------+
| Firefox                   | 59.0 - 80.0                                                                                   |
+---------------------------+-----------------------------------------------------------------------------------------------+

.. note::

    For Windows desktops using **Chrome** or **Firefox** you should disable the option ``touch-events`` of your browser:

    **Chrome**: chrome://flags -> #touch-events: disabled.
    **Firefox**: about:config -> dom.w3c_touch_events: disabled.

    Internet Explorer is **not** supported with the Compatibility Mode enabled, since it emulates IE7 which is not supported.


VMware Cloud on AWS
--------------------------------------------------------------------------------

OpenNebula has been validated and is supported on VMware Cloud on AWS. Customers can contact the support team through the commercial support portal to know specific configuration and limitations.

.. note:: Generally for all Linux platforms, it is worth noting that Ruby gems should be used from packages shipped with OpenNebula or installed with the :ref:`install_gems <ruby_runtime>` utility. Avoid using Ruby gems versions shipped with your platform.


Certified Infrastructure Scale
================================================================================

A single instance of OpenNebula (ie, a single ``oned`` process) has been stress-tested to cope with 500 hypervisors without performance degradation. This is the maximum recommended configuration for a single instance, and depending on the underlying configuration of storage and networking mainly, it is recommended to switch to a federated scenario for any larger number of hypervisors.

However, there are several OpenNebula users managing significant higher numbers of hypervisors (on the order of two thousand) with a single instance. This largely depends, as mentioned, on the storage, networking and also monitoring configuration.

Frontend Platform Notes
================================================================================

The following applies to all Front-Ends:

* XML-RPC tuning parameters (``MAX_CONN``, ``MAX_CONN_BACKLOG``, ``KEEPALIVE_TIMEOUT``, ``KEEPALIVE_MAX_CONN`` and ``TIMEOUT``) are only available with packages distributed by us, as they are compiled with a newer xmlrpc-c library.
* Only **Ruby versions >= 2.0 are supported**.

Ubuntu 16.04 Platform Notes
--------------------------------------------------------------------------------

By default it comes with LXD 2. LXD 3 should be installed from **xenial-backports**. Make sure you have `backports enabled in sources.list <https://help.ubuntu.com/community/UbuntuBackports>`_

.. prompt:: bash # auto

    # apt-get -t xenial-backports install lxd

Resizing **ext4** filesystems of LXD containers will fail due to the outdated ``e2fsck`` package.

CentOS 7.0 Platform Notes
--------------------------------------------------------------------------------

When using Apache to serve Sunstone, it is required that you disable or comment the ``PrivateTMP=yes`` directive in ``/usr/lib/systemd/system/httpd.service``.

There is an automatic job that removes all data from ``/var/tmp/``. In order to disable this, please edit the ``/usr/lib/tmpfiles.d/tmp.conf`` and remove the line that removes ``/var/tmp``.

There is a bug in libvirt that the prevents the use of the save/restore mechanism if ``cpu_model`` is set to ``'host-passthrough'`` via ``RAW``. The `work around if needed is described in this issue <http://dev.opennebula.org/issues/4204>`__.

Debian 8
--------------------------------------------------------------------------------

Make sure that the packages ``ruby-treetop`` and ``treetop`` are not installed before running ``ìnstall_gems``, as the version of ``treetop`` that comes packaged in Debian 8 is incompatible with OpenNebula. **OneFlow** requires a version >= 1.6.3 for treetop, packages distributed with Debian 8 includes an older version (1.4.5).


Nodes Platform Notes
================================================================================

The following items apply to all distributions:

* Since OpenNebula 4.14 there is a new monitoring probe that gets
  information about PCI devices. By default it retrieves all the PCI
  devices in a host. To limit the PCI devices for which it gets info and appear in ``onehost show`` refer to :ref:`kvm_pci_passthrough`.
* When using qcow2 storage drivers you can make sure that the data is written to disk when doing snapshots setting the ``cache`` parameter to ``writethrough``. This change will make writes slower than other cache modes but safer. To do this edit the file ``/etc/one/vmm_exec/vmm_exec_kvm.conf`` and change the line for ``DISK``:

.. code::

    DISK = [ driver = "qcow2", cache = "writethrough" ]

CentOS/RedHat 7 Platform Notes
--------------------------------------------------------------------------------

Ruby Dependencies
~~~~~~~~~~~~~~~~~

In order to install Ruby dependencies on RHEL, the Server Optional channel needs to be enabled. Please refer to `RedHat documentation <https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/>`__ to enable the channel.

Alternatively, use CentOS 7 repositories to install Ruby dependencies.

Libvirt Version
~~~~~~~~~~~~~~~

The libvirt/QEMU packages used in the testing infrastructure are the ones in the ``qemu-ev`` repository. To add this repository on CentOS, you can install the following packages:

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


CentOS/RedHat 8 Platform Notes
--------------------------------------------------------------------------------

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
