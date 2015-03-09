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
| Ubuntu Server                | 14.04 (LTS)                           |   |   |
+------------------------------+---------------------------------------+---+---+
| CentOS                       | 6.5, 7.0                              |   |   |
+------------------------------+---------------------------------------+---+---+
| Debian                       | 7.1                                   |   |   |
+------------------------------+---------------------------------------+---+---+
| VMware                       | ESX 5.5 & vCenter 5.5                 |   |   |
+------------------------------+---------------------------------------+---+---+
| XEN                          | 3.2 & 4.2                             |   |   |
+------------------------------+---------------------------------------+---+---+
| KVM                          | Supported version that is included in |   |   |
|                              | the kernel for the Linux distribution |   |   |
+------------------------------+---------------------------------------+---+---+
| Amazon Web Service           | Current API version                   |   |   |
+------------------------------+---------------------------------------+---+---+
| Microsoft Azure              | Current API version                   |   |   |
+------------------------------+---------------------------------------+---+---+
| IBM SoftLayer                | Current API version                   |   |   |
+------------------------------+---------------------------------------+---+---+

All Front-Ends
==============

-  xmlrpc tuning parameters (MAX\_CONN, MAX\_CONN\_BACKLOG, KEEPALIVE\_TIMEOUT, KEEPALIVE\_MAX\_CONN and TIMEOUT) are only available with packages distributed by us as they are compiled with a newer xmlrpc-c library.

-  for **cloud bursting**, a newer nokogiri gem than the one packed by current distros is required. If you are planning to use cloud bursting, you need to install nokogiri >= 1.4.4 prior to run ``install_gems``

.. code::

    # sudo gem install nokogiri -v 1.4.4

- also for **cloud bursting**, precisely for Microsoft Azure and IBM SoftLayer, those supported distros with ruby versions <= 1.9.3 (like Centos 6.x) please update the ruby installation or use `rvm <https://rvm.io/>`__ to run a newer (>= 1.9.3) version (remember to run ``install_gems`` after the ruby upgrade is done to reinstall all gems)

ESX 5.5 as VMware Node
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

CentOS 6.5 as KVM Node
----------------------

-  to accomplish disk hotplugging:

   -  disks need to be attached through SCSI, so their images should have a DEV\_PREFIX=“sd”
   -  VM template that will permit SCSI disk attaches afterwards needs to have an explicitly defined SCSI controller:

.. code::

    RAW=[TYPE = "kvm",
         DATA = "<devices><controller type='scsi' index='0' model='virtio-scsi'></controller></devices>"]

-  due to libvirt version < = 0.10.2, there is a `bug in libvrit/qemu attac/detach nic functionality <https://bugzilla.redhat.com/show_bug.cgi?id=813748>`__ that prevents the reuse of net IDs. This means that after a successful attach/detach NIC, a new attach will fail.

Ubuntu 14.04 with Cloud Bursting
--------------------------------

The aws-sdk gem is needed for the hybrid model in OpenNebula to access Amazon EC2, but it is tricky to compile in Ubuntu 14.04. To install the dependency:

.. code::

    $ sudo gem install nokogiri --version 1.6.1 -- --use-system-libraries
    $ sudo gem install aws-sdk

CentOS 6.5 Usage Platform Notes
===============================

Because home directory of oneadmin is located in ``/var``, it violates SELinux default policy. So in ssh passwordless configuration you should disable SELinux by setting ``SELINUX=disabled`` in ``/etc/selinux/config``.

CentOS 7.0 Platform Notes
=========================

This distribution lacks some packaged ruby libraries. This makes some components unusable until they are installed. In the frontend, just after package installation these command should be executed as root to install extra dependencies:

.. code::

    # /usr/share/one/install_gems

The ``qemu-kvm`` package does not include support for ``RBD`` therefore it's not possible to use it in combination with Ceph.

RedHat 6.5 & 7.0 Platform Notes
===============================

In order to install ruby dependencies, the Server Optional channel needs to be enabled. Please refer to `RedHat documentation <https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/>`__ to enable the channel.

Alternatively, use CentOS 6.5 or 7 repositories to install ruby dependencies.

Debian Platform Notes
=====================

Debian Lenny as Xen 3 Node
--------------------------

-  The `xen packages on Debian Lenny seem to be broken, and they don't work with the tap:aio interface <http://lists.alioth.debian.org/pipermail/pkg-xen-devel/2009-June/003.04.html>`__. A workaround for this problem is the following:

.. code::

    # ln -s /usr/lib/xen-3.2-1/bin/tapdisk /usr/sbin
    # echo xenblktap >> /etc/modules
    # reboot

Ubuntu 14.04 Platform Notes
===========================

-  Limited startup scripts → only for OpenNebula service

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

