.. _uspng:

================================================================================
Platform Notes 6.4.8
================================================================================

This page will show you the specific considerations when using an OpenNebula cloud, according to the different supported platforms.

This is the list of the individual platform components that have been through the complete `OpenNebula Quality Assurance and Certification Process <https://github.com/OpenNebula/one/wiki/Quality-Assurance>`__.

Certified Components Version
================================================================================

Front-End Components
--------------------------------------------------------------------------------

+--------------------------+--------------------------------------------------------+-------------------------------------------------------+
|        Component         |                        Version                         |                    More information                   |
+==========================+========================================================+=======================================================+
| Red Hat Enterprise Linux | 8, 9                                                   | :ref:`Front-End Installation <frontend_installation>` |
+--------------------------+--------------------------------------------------------+-------------------------------------------------------+
| AlmaLinux                | 8, 9                                                   | :ref:`Front-End Installation <frontend_installation>` |
+--------------------------+--------------------------------------------------------+-------------------------------------------------------+
| Ubuntu Server            | 20.04, 22.04, 24.04                                    | :ref:`Front-End Installation <frontend_installation>` |
+--------------------------+--------------------------------------------------------+-------------------------------------------------------+
| Debian                   | 11, 12                                                 | :ref:`Front-End Installation <frontend_installation>`.|
|                          |                                                        | Not certified to manage VMware infrastructures        |
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

.. _vcenter_nodes_platform_notes:

vCenter Nodes
--------------------------------------------------------------------------------

+-----------+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------+
| Component |                Version                |                                                            More information                                                            |
+===========+=======================================+========================================================================================================================================+
| vCenter   | 7.0.x, managing ESX 7.0.x             | :ref:`vCenter Node Installation <vcenter_node>`                                                                                        |
+-----------+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------+
| NSX-T     | 2.4.1+                                | `VMware compatiblity <https://www.vmware.com/resources/compatibility/sim/interop_matrix.php>`__. :ref:`NSX Documentation <nsx_setup>`. |
+-----------+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------+
| NSX-V     | 6.4.8+                                | `VMware compatiblity <https://www.vmware.com/resources/compatibility/sim/interop_matrix.php>`__. :ref:`NSX Documentation <nsx_setup>`  |
+-----------+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------+

.. note:: Debian front-ends are not certified to manage VMware infrastructures with OpenNebula.

KVM Nodes
--------------------------------------------------------------------------------

+--------------------------+---------------------------------------------------------+-----------------------------------------+
|        Component         |                         Version                         |             More information            |
+==========================+=========================================================+=========================================+
| Red Hat Enterprise Linux | 7, 8, 9                                                 | :ref:`KVM Driver <kvmg>`                |
+--------------------------+---------------------------------------------------------+-----------------------------------------+
| CentOS                   | 7                                                       | :ref:`KVM Driver <kvmg>`                |
+--------------------------+---------------------------------------------------------+-----------------------------------------+
| AlmaLinux                | 8, 9                                                    | :ref:`KVM Driver <kvmg>`                |
+--------------------------+---------------------------------------------------------+-----------------------------------------+
| Ubuntu Server            | 18.04 (LTS), 20.04 (LTS), 22.04 (LTS)                   | :ref:`KVM Driver <kvmg>`                |
+--------------------------+---------------------------------------------------------+-----------------------------------------+
| Debian                   | 10, 11                                                  | :ref:`KVM Driver <kvmg>`                |
+--------------------------+---------------------------------------------------------+-----------------------------------------+
| KVM/Libvirt              | Support for version included in the Linux distribution. | :ref:`KVM Node Installation <kvm_node>` |
|                          | For CentOS/RHEL the packages from ``qemu-ev`` are used. |                                         |
+--------------------------+---------------------------------------------------------+-----------------------------------------+

LXC Nodes
--------------------------------------------------------------------------------

+---------------+--------------------------------------------------------+-----------------------------------------+
|   Component   |                        Version                         |             More information            |
+===============+========================================================+=========================================+
| Ubuntu Server | 18.04 (LTS), 20.04 (LTS), 22.04 (LTS)                  | :ref:`LXC Driver <lxcmg>`               |
+---------------+--------------------------------------------------------+-----------------------------------------+
| Debian        | 10, 11                                                 | :ref:`LXC Driver <lxcmg>`               |
+---------------+--------------------------------------------------------+-----------------------------------------+
| AlmaLinux     | 8, 9                                                   | :ref:`LXC Driver <lxcmg>`               |
+---------------+--------------------------------------------------------+-----------------------------------------+
| LXC           | Support for version included in the Linux distribution | :ref:`LXC Node Installation <lxc_node>` |
+---------------+--------------------------------------------------------+-----------------------------------------+

Firecracker Nodes
--------------------------------------------------------------------------------

+--------------------------+-------------------------------------------------+----------------------------------+
|        Component         |                     Version                     |         More information         |
+==========================+=================================================+==================================+
| Red Hat Enterprise Linux | 7, 8, 9                                         | :ref:`Firecracker Driver <fcmg>` |
+--------------------------+-------------------------------------------------+----------------------------------+
| CentOS                   | 7                                               | :ref:`Firecracker Driver <fcmg>` |
+--------------------------+-------------------------------------------------+----------------------------------+
| AlmaLinux                | 8, 9                                            | :ref:`Firecracker Driver <fcmg>` |
+--------------------------+-------------------------------------------------+----------------------------------+
| Ubuntu Server            | 18.04 (LTS), 20.04 (LTS), 22.04 (LTS)           | :ref:`Firecracker Driver <fcmg>` |
+--------------------------+-------------------------------------------------+----------------------------------+
| Debian                   | 10, 11                                          | :ref:`Firecracker Driver <fcmg>` |
+--------------------------+-------------------------------------------------+----------------------------------+
| KVM/Firecracker          | Support for Firecracker and KVM versions        | :ref:`Firecracker Node           |
|                          | included in the Linux distribution.             | Installation <fc_node>`          |
+--------------------------+-------------------------------------------------+----------------------------------+

.. _context_supported_platforms:

Linux Contextualization Packages
---------------------------------------------------------------------------------

+------------------------------+---------------------------------------------------------+------------------------------------------------------------------------------------------+
|          Component           |              Version                                    |                                     More information                                     |
+==============================+=========================================================+==========================================================================================+
| AlmaLinux                    | 8                                                       | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+---------------------------------------------------------+------------------------------------------------------------------------------------------+
| Alpine Linux                 | 3.13, 3.14, 3.15                                        | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+---------------------------------------------------------+------------------------------------------------------------------------------------------+
| ALT Linux                    | p9, p10, Sisyphus                                       | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+---------------------------------------------------------+------------------------------------------------------------------------------------------+
| Amazon Linux                 | 2                                                       | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+---------------------------------------------------------+------------------------------------------------------------------------------------------+
| CentOS                       | 7, 8 Stream                                             | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+---------------------------------------------------------+------------------------------------------------------------------------------------------+
| Debian                       | 10, 11, 12                                              | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+---------------------------------------------------------+------------------------------------------------------------------------------------------+
| Devuan                       | 2                                                       | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+---------------------------------------------------------+------------------------------------------------------------------------------------------+
| Fedora                       | 34, 35                                                  | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+---------------------------------------------------------+------------------------------------------------------------------------------------------+
| FreeBSD                      | 12, 13                                                  | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+---------------------------------------------------------+------------------------------------------------------------------------------------------+
| openSUSE                     | 15                                                      | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+---------------------------------------------------------+------------------------------------------------------------------------------------------+
| Oracle Linux                 | 7, 8                                                    | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+---------------------------------------------------------+------------------------------------------------------------------------------------------+
| Red Hat Enterprise Linux     | 7, 8                                                    | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+---------------------------------------------------------+------------------------------------------------------------------------------------------+
| Rocky Linux                  | 8                                                       | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+---------------------------------------------------------+------------------------------------------------------------------------------------------+
| Ubuntu                       | 14.04, 16.04, 18.04, 20.04, 22.04                       | `Linux Contextualization Packages <https://github.com/OpenNebula/addon-context-linux>`__ |
+------------------------------+---------------------------------------------------------+------------------------------------------------------------------------------------------+

Windows Contextualization Packages
---------------------------------------------------------------------------------


+----------------------------+-------------------------+
|   Component                | Version                 |
+============================+=========================+
| Windows                    | 10+                     |
+----------------------------+-------------------------+
| Windows Server             | 2016+                   |
+----------------------------+-------------------------+

`More information <https://github.com/OpenNebula/addon-context-windows>`_


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
| Ceph      | Pacific v16.2.x                            | :ref:`The Ceph Datastore <ceph_ds>` |
|           | Quincy  v17.2.x                            |                                     |
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

Application Containerization
--------------------------------------------------------------------------------

+------------------------------+--------------------------------------------+
|             Component        |                  Version                   |
+==============================+============================================+
| Docker                       | 20.10.5 CE                                 |
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
| Chrome                    | 61.0 - 94.0                                                                                   |
+---------------------------+-----------------------------------------------------------------------------------------------+
| Firefox                   | 59.0 - 92.0                                                                                   |
+---------------------------+-----------------------------------------------------------------------------------------------+

.. note::

    For Windows desktops using **Chrome** or **Firefox** you should disable the option ``touch-events`` for your browser:

    **Chrome**: chrome://flags -> #touch-events: disabled.
    **Firefox**: about:config -> dom.w3c_touch_events: disabled.

.. note:: Generally, for all Linux platforms, it is worth noting that Ruby gems should be used from packages shipped with OpenNebula or installed with the :ref:`install_gems <ruby_runtime>` utility. Avoid using Ruby gem versions shipped with your platform.

.. _edge_cluster_provision_workloads_compatibility:

Compatibility of Workloads on Certified Edge Clusters
=====================================================

.. include:: ../release_notes/edge_clusters.txt

Certified Infrastructure Scale
================================================================================

A single instance of OpenNebula (i.e., a single ``oned`` process) has been stress-tested to cope with 500 hypervisors without performance degradation. This is the maximum recommended configuration for a single instance, and depending on the underlying configuration of storage and networking, it is mainly recommended to switch to a federated scenario for any larger number of hypervisors.

However, there are several OpenNebula users managing significantly higher numbers of hypervisors (to the order of two thousand) with a single instance. This largely depends, as mentioned, on the storage, networking, and also monitoring configuration.

Front-End Platform Notes
================================================================================

The following applies to all Front-Ends:

* XML-RPC tuning parameters (``MAX_CONN``, ``MAX_CONN_BACKLOG``, ``KEEPALIVE_TIMEOUT``, ``KEEPALIVE_MAX_CONN`` and ``TIMEOUT``) are only available with packages distributed by us, as they are compiled with a newer xmlrpc-c library.
* Only **Ruby versions >= 2.0 are supported**.
* Most Linux distributions using a kernel 5.X (i.e. Debian 11) mount cgroups v2 via systemd natively. If you have hosts with a previous version of the distribution mounting cgroups via fstab or in v1 compatibility mode (i.e. Debian 10) and their libvirt version is <5.5, during the migration of VMs from older hosts to new ones you can experience errors like

.. code::

    WWW MMM DD hh:mm:ss yyyy: MIGRATE: error: Unable to write to '/sys/fs/cgroup/machine.slice/machine-qemu/..../cpu.weight': Numerical result out of range Could not migrate VM_UID to HOST ExitCode: 1

This happens in every single VM migration from a host with the previous OS version to a host with the new one.

To solve this, there are 2 options: Delete the VM and recreate it scheduled in a host with the new OS version or mount cgroups in v1 compatibility mode in the nodes with the new OS version. To do this

    1. Edit the bootloader default options (normally under ``/etc/defaults/grub.conf``)
    2. Modify the default commandline for the nodes (usually ``GRUB_CMDLINE_LINUX="..."``) and add the option ``systemd.unified_cgroup_hierarchy=0``
    3. Recreate the grub configuration file (in most cases executing a ``grub-mkconfig -o /boot/grub/grub.cfg``)
    4. Reboot the host. The change will be persistent if the kernel is updated

CentOS 7.0
--------------------------------------------------------------------------------

When using Apache to serve Sunstone, it is required that you disable or comment the ``PrivateTMP=yes`` directive in ``/usr/lib/systemd/system/httpd.service``.

There is an automatic job that removes all data from ``/var/tmp/``. In order to disable this, please edit the ``/usr/lib/tmpfiles.d/tmp.conf`` and remove the line that removes ``/var/tmp``.

There is a bug in libvirt that prevents the use of the save/restore mechanism if ``cpu_model`` is set to ``'host-passthrough'`` via ``RAW``. The `work around if needed is described in this issue <http://dev.opennebula.org/issues/4204>`__.

Ubuntu 18.04
--------------------------------------------------------------------------------

In order to automatically convert images to ``vmdk`` (when downloading an application from a marketplace into a vCenter datastore or cloning images across different datastore types) OpenNebula requires ``qemu-img version 4.2.1``. Installing this version in Ubuntu 18.04 is not trivial, so we recommend and upgrade to Ubuntu 20.04 if you need to make use of this functionality.

Ubuntu 20.04
--------------------------------------------------------------------------------

When using Apache to serve Sunstone, it's required to grant read permissions to the user running ``httpd`` in ``/var/lib/one``.


Ubuntu 22.04
--------------------------------------------------------------------------------

Ubuntu 22.04 ships with ruby3 by default, which deprecates URI.escape method, used by the rbvmomi gem. This implies that `vCenter upload/download functionality is broken in Ubuntu 22.04 <https://github.com/OpenNebula/one/issues/5996>`__.

Debian 11
--------------------------------------------------------------------------------

There is currently no support for `Phusion Passenger on Debian 11 <https://oss-binaries.phusionpassenger.com/apt/passenger/dists/>`__, so it is currently not possible to deploy :ref:`Sunstone in a Apache/Passenger configuration <suns_advance_web_proxy>`.

AlmaLinux 9
--------------------------------------------------------------------------------

There is currently no support for `Phusion Passenger on AlmaLinux 9 <https://oss-binaries.phusionpassenger.com/yum/passenger/el/>`__, so it is currently not possible to deploy :ref:`Sunstone in a Apache/Passenger configuration <suns_advance_web_proxy>`.

Nodes Platform Notes
================================================================================

The following items apply to all distributions:

* Since OpenNebula 4.14 there is a new monitoring probe that gets information about PCI devices. By default it retrieves all the PCI devices in a Host. To limit the PCI devices for which it gets info and appear in ``onehost show``, refer to :ref:`kvm_pci_passthrough`.
* When using qcow2 storage drivers you can make sure that the data is written to disk when doing snapshots by setting the ``cache`` parameter to ``writethrough``. This change will make writes slower than other cache modes but safer. To do this edit the file ``/etc/one/vmm_exec/vmm_exec_kvm.conf`` and change the line for ``DISK``:

.. code::

    DISK = [ driver = "qcow2", cache = "writethrough" ]

CentOS/RedHat 7 Platform Notes
--------------------------------------------------------------------------------

RAdded details in case that some hosts in a cluster have incompatibility about the version of cgroups mounted

uby Dependencies
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In order to install Ruby dependencies on RHEL, the Server Optional channel needs to be enabled. Please refer to `RedHat documentation <https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/>`__ to enable the channel.

Alternatively, use CentOS 7 repositories to install Ruby dependencies.

Libvirt Version
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The libvirt/QEMU packages used in the testing infrastructure are the ones in the ``qemu-ev`` repository. To add this repository on CentOS, you can install the following packages:

.. prompt:: bash # auto

    # yum install centos-release-qemu-ev
    # yum install qemu-kvm-ev

Disable PolicyKit for Libvirt
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

It is recommended that you disable PolicyKit for Libvirt:

.. prompt:: bash $ auto

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
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

It is recommended that you disable PolicyKit for Libvirt:

.. prompt:: bash $ auto

    $ cat /etc/libvirt/libvirtd.conf
    ...
    auth_unix_ro = "none"
    auth_unix_rw = "none"
    unix_sock_group = "oneadmin"
    unix_sock_ro_perms = "0770"
    unix_sock_rw_perms = "0770"
    ...

AlmaLinux 9 Platform Notes
--------------------------------------------------------------------------------

Disable Libvirtd's SystemD Socket Activation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

OpenNebula currently works only with the legacy ``livirtd.service``. You should disable libvirt's modular daemons and systemd socket activation for the ``libvirtd.service``.
You can take a look at `this <https://github.com/OpenNebula/one/issues/6143>`__ bug report, for a detailed workaround procedure.

vCenter 7.0 Platform Notes
--------------------------------------------------------------------------------

Problem with Boot Order
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Currently in vCenter 7.0 changing the boot order is only supported in Virtual Machines at deployment time.

Debian 10 and Ubuntu 18 Upgrade
--------------------------------------------------------------------------------

When upgrading your nodes from Debian 10 or Ubuntu 18 you may need to update the opennebula sudoers file because of the */usr merge* feature implemented for Debian11/Ubuntu20. You can `find more information and a recommended work around in this issue  <https://github.com/OpenNebula/one/issues/6090>`__.
