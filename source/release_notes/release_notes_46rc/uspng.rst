.. _uspng_46rc:

===============
Platform Notes
===============

This page will show you the specific considerations at the time of using an OpenNebula cloud, according to the different supported platforms.

This is the list of the individual platform components that have been through the complete `OpenNebula Quality Assurance and Certification Process <http://opennebula.org/software:testing>`__.

+--------------------------------+-------------------------------------------------------------------------------+
| Certified Platform Component   | Version                                                                       |
+================================+===============================================================================+
| RedHat Enterprise Linux        | 6.4                                                                           |
+--------------------------------+-------------------------------------------------------------------------------+
| Ubuntu Server                  | 12.04 (LTS) & 13.04                                                           |
+--------------------------------+-------------------------------------------------------------------------------+
| SUSE Linux Enterprise          | 12.3                                                                          |
+--------------------------------+-------------------------------------------------------------------------------+
| CentOS                         | 6.4                                                                           |
+--------------------------------+-------------------------------------------------------------------------------+
| openSUSE                       | 12.3                                                                          |
+--------------------------------+-------------------------------------------------------------------------------+
| Debian                         | 7.1                                                                           |
+--------------------------------+-------------------------------------------------------------------------------+
| VMware                         | ESX 5.0 & ESX 5.1                                                             |
+--------------------------------+-------------------------------------------------------------------------------+
| XEN                            | 3.2 & 4.2                                                                     |
+--------------------------------+-------------------------------------------------------------------------------+
| KVM                            | Supported version that is included in the kernel for the Linux distribution   |
+--------------------------------+-------------------------------------------------------------------------------+

All Front-Ends
==============

-  xmlrpc tuning parameters (MAX\_CONN, MAX\_CONN\_BACKLOG, KEEPALIVE\_TIMEOUT, KEEPALIVE\_MAX\_CONN and TIMEOUT) are only available with packages distributed by us as they are compiled with a newer xmlrpc-c library.

-  for **cloud bursting**, a newer nokogiri gem than the on packed by current distros is required. If you are planning to use cloud bursting, you need to install nokogiri >= 1.4.4 prior to run ``install_gems``

.. code::

    # sudo gem install nokogiri -v 1.4.4

ESX 5.x as VMware Node
----------------------

-  to accomplish disk hotplugging and nic hotplugging (ignore the first bullet for the latter)

   -  disks need to be attached through SCSI, so their images should have a DEV\_PREFIX=“sd”
   -  VM template that will permit SCSI disk attaches afterwards needs to have an explicitly defined SCSI controller:

.. code::

    RAW=[TYPE = "vmware",
         DATA = "<devices><controller type='scsi' index='0' model='lsilogic'/></devices>"]

-  to use SCSI disk based VMs, it is usually a good idea to explicitly declare the PCI bridges. This can be accomplished with the following added to the VM template:

.. code::

     FEATURES=[PCIBRIDGE="1"]

-  to accomplish hot migration (through vMotion)

   -  VM needs to have all network card model with model “E1000”

CentOS 6.4 as KVM Node
----------------------

-  to accomplish disk hotplugging:

   -  disks need to be attached through SCSI, so their images should have a DEV\_PREFIX=“sd”
   -  VM template that will permit SCSI disk attaches afterwards needs to have an explicitly defined SCSI controller:

.. code::

    RAW=[TYPE = "kvm",
         DATA = "<devices><controller type='scsi' index='0' model='virtio-scsi'></controller></devices>"]

-  due to libvirt version < = 0.10.2, there is a `bug in libvrit/qemu attac/detach nic functionality <https://bugzilla.redhat.com/show_bug.cgi?id=813748>`__ that prevents the reuse of net IDs. This means that after a successful attach/detach NIC, a new attach will fail.

Ubuntu 12.04 as KVM Node
------------------------

-  due to libvirt version < = 0.10.2, there is a `bug in libvrit/qemu attac/detach nic functionality <https://bugzilla.redhat.com/show_bug.cgi?id=813748>`__ that prevents the reuse of net IDs. This means that after a successful attach/detach NIC, a new attach will fail.

CentOS 6.4 Usage Platform Notes
===============================

Because home directory of oneadmin is located in ``/var``, it violates SELinux default policy. So in ssh passwordless configuration you should disable SELinux by setting ``SELINUX=disabled`` in ``/etc/selinux/config``.

Debian Platform Notes
=====================

Debian Lenny as Xen 3 Node
--------------------------

-  The `xen packages on Debian Lenny seem to be broken, and they don't work with the tap:aio interface <http://lists.alioth.debian.org/pipermail/pkg-xen-devel/2009-June/003.04.html>`__. A workaround for this problem is the following:

.. code::

    # ln -s /usr/lib/xen-3.2-1/bin/tapdisk /usr/sbin
    # echo xenblktap >> /etc/modules
    # reboot

openSUSE 12.3 Platform Notes
============================

-  Limited startup scripts → only for OpenNebula and Sunstone services

Ubuntu 12.04 Platform Notes
===========================

-  Limited startup scripts → only for OpenNebula service
-  Ubuntu12.04 presents libvirt 0.9.8. We recommend updating (manually, there are no packages) to 0.10.2 to use the AttachNic and DetachNic functionality.

Ubuntu 13.04 Platform Notes
===========================

-  Limited startup scripts → only for OpenNebula service

Unsupported Platforms Notes
===========================

Installing on ArchLinux
-----------------------

OpenNebula is available at the Arch User Repository (AUR), `please check the opennebula package page <https://aur.archlinux.org/packages.php?ID=32163>`__.

Installing on Gentoo
--------------------

You need to compile the xmlrpc-c package with threads support, as:

.. code::

      USE="threads" emerge xmlrpc-c

