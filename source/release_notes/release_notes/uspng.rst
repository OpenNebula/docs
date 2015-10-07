.. _uspng:

===============
Platform Notes
===============

This page will show you the specific considerations at the time of using an OpenNebula cloud, according to the different supported platforms.

This is the list of the individual platform components that have been through the complete `OpenNebula Quality Assurance and Certification Process <http://opennebula.org/software:testing>`__.

+------------------------------+---------------------------------------+---+---+
| Certified Platform Component |                Version                |   |   |
+==============================+=======================================+===+===+
| RedHat Enterprise Linux      | 6.5, 7.0                              |   |   |
+------------------------------+---------------------------------------+---+---+
| Ubuntu Server                | 14.04 (LTS) , 15.04                   |   |   |
+------------------------------+---------------------------------------+---+---+
| CentOS                       | 6.5, 7.0                              |   |   |
+------------------------------+---------------------------------------+---+---+
| Debian                       | 8                                     |   |   |
+------------------------------+---------------------------------------+---+---+
| VMware                       | ESX 5.5/6.0 & vCenter 5.5/6.0         |   |   |
+------------------------------+---------------------------------------+---+---+
| XEN                          | 3.2 & 4.2                             |   |   |
+------------------------------+---------------------------------------+---+---+
| KVM                          | Support for version included in       |   |   |
|                              | the kernel for the Linux distribution |   |   |
+------------------------------+---------------------------------------+---+---+
| Amazon Web Service           | Current API version                   |   |   |
+------------------------------+---------------------------------------+---+---+
| Microsoft Azure              | Current API version                   |   |   |
+------------------------------+---------------------------------------+---+---+
| IBM SoftLayer                | Current API version                   |   |   |
+------------------------------+---------------------------------------+---+---+

Front-End Platform Notes
========================

The following applies to all Front-Ends:

-  xmlrpc tuning parameters (MAX\_CONN, MAX\_CONN\_BACKLOG, KEEPALIVE\_TIMEOUT, KEEPALIVE\_MAX\_CONN and TIMEOUT) are only available with packages distributed by us as they are compiled with a newer xmlrpc-c library.

-  for **cloud bursting**, a newer nokogiri gem than the one packed by current distros is required. If you are planning to use cloud bursting, you need to install nokogiri >= 1.4.4 prior to run ``install_gems``

.. code::

    # sudo gem install nokogiri -v 1.4.4

- older ruby versions are not supported for **cloud bursting** (precisely for Microsoft Azure and IBM SoftLayer) and the :ref:`Sunstone commercial support integration <commercial_support_sunstone>`. For those supported distros with ruby versions <= 1.9.3 (like Centos 6.x) please update the ruby installation or use `rvm <https://rvm.io/>`__ to run a newer (>= 1.9.3) version (remember to run ``install_gems`` after the ruby upgrade is done to reinstall all gems)

- **OneFlow** requires a version >= 1.6.3 for treetop, packages distributed with Debian 8 includes an older version (1.4.5) and must be removed


CentOS Platform Notes
=====================

CentOS 6.5 Usage Platform Notes
-------------------------------

Because home directory of oneadmin is located in ``/var``, it violates SELinux default policy. So in ssh passwordless configuration you should disable SELinux by setting ``SELINUX=disabled`` in ``/etc/selinux/config``.

CentOS 7.0 Platform Notes
-------------------------

This distribution lacks some packaged ruby libraries. This makes some components unusable until they are installed. In the frontend, just after package installation these commands should be executed as root to install extra dependencies:

.. code::

    # yum install openssl-devel
    # /usr/share/one/install_gems

When using Apache to serve Sunstone, it is required that you disable or comment the ``PrivateTMP=yes`` directive in ``/usr/lib/systemd/system/httpd.service``.

There is an automatic job that removes all data from ``/var/tmp/``, in order to disable this, please edit the ``/usr/lib/tmpfiles.d/tmp.conf`` and re ove the line that removes ``/var/tmp``.


RedHat 6.5 & 7.0 Platform Notes
===============================

In order to install ruby dependencies, the Server Optional channel needs to be enabled. Please refer to `RedHat documentation <https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/>`__ to enable the channel.

Alternatively, use CentOS 6.5 or 7 repositories to install ruby dependencies.

Nodes Platform Notes
====================

-  Since OpenNebula 4.14 there is a new monitoring probe that gets information about PCI devices. By default it retrieves all the PCI devices in a host. To limit the PCI devices that it gets info and appear in ``onehost show`` refer to :ref:`kvm_pci_passthrough`.

ESX 5.5 as VMware Node
======================

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

CentOS 6.5 as KVM Node
======================

-  to accomplish disk hotplugging:

   -  disks need to be attached through SCSI, so their images should have a DEV\_PREFIX=“sd”
   -  VM template that will permit SCSI disk attaches afterwards needs to have an explicitly defined SCSI controller:

.. code::

    RAW=[TYPE = "kvm",
         DATA = "<devices><controller type='scsi' index='0' model='virtio-scsi'></controller></devices>"]

-  due to libvirt version < = 0.10.2, there is a `bug in libvrit/qemu attac/detach nic functionality <https://bugzilla.redhat.com/show_bug.cgi?id=813748>`__ that prevents the reuse of net IDs. This means that after a successful attach/detach NIC, a new attach will fail.

Unsupported Platforms Notes
===========================

Installing on ArchLinux
-----------------------

OpenNebula is available at the Arch User Repository (AUR), `please check the opennebula package page <https://aur.archlinux.org/packages.php?ID=32163>`__.

Installing on Gentoo
--------------------

There is an ebuild contributed by Thomas Stein in the following repository:

https://github.com/himbeere/opennebula

Still, if you want to compile it manually you need to install the xmlrpc-c package with threads support, as:

.. code::

      USE="threads" emerge xmlrpc-c

