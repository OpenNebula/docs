.. _xeng:

===========
Xen Driver
===========

The `XEN hypervisor <http://www.xen.org>`__ offers a powerful, efficient and secure feature set for virtualization of x86, IA64, PowerPC and other CPU architectures. It delivers both paravirtualization and full virtualization. This guide describes the use of Xen with OpenNebula, please refer to the Xen specific documentation for further information on the setup of the Xen hypervisor itself.

Requirements
============

The Hosts must have a working installation of Xen that includes a Xen aware kernel running in Dom0 and the Xen utilities.

Considerations & Limitations
============================

-  Xen HVM currently only supports 4 IDE devices, for more disk devices you should better use SCSI. You have to take this into account when adding disks. See the :ref:`Virtual Machine Template documentation <template#disks_device_mapping>` for an explanation on how OpenNebula assigns disk targets.
-  OpenNebula manages kernel and initrd files. You are encouraged to register them in the :ref:`files datastore <img_guide#kernel_and_ramdisk>`.
-  To modify the default disk driver to one that works with your Xen version you can change the files ``/etc/one/vmm_exec/vmm_exec_xen*.conf`` and ``/var/lib/one/remotes/vmm/xen*/xenrc``. Make sure that you have ``blktap2`` modules loaded to use ``tap2:tapdisk:aio``:

.. code::

    export IMAGE_PREFIX="tap2:tapdisk:aio"

.. code::

    DISK   = [ driver = "tap2:tapdisk:aio:" ]

-  If target device is not supported by the linux kernel you will be able to attach disks but not detach them. It is recomended to attach ``xvd`` devices for xen paravirtualized hosts.

Configuration
=============

Xen Configuration
-----------------

In each Host you must perform the following steps to get the driver running:

-  The remote hosts must have the xend daemon running (``/etc/init.d/xend``) and a ``XEN`` aware kernel running in Dom0

-  The ``<oneadmin>`` user may need to execute Xen commands using root privileges. This can be done by adding this two lines to the ``sudoers`` file of the hosts so ``<oneadmin>`` user can execute Xen commands as root (change paths to suit your installation):

.. code::

    %xen    ALL=(ALL) NOPASSWD: /usr/sbin/xm *
    %xen    ALL=(ALL) NOPASSWD: /usr/sbin/xentop *

-  You may also want to configure network for the virtual machines. OpenNebula assumes that the VMs have network access through standard bridging, `please refer to the Xen documentation <http://wiki.xenproject.org/wiki/Xen_Networking>`__ to configure the network for your site.

-  Some distributions have **requiretty** option enabled in the ``sudoers`` file. It must be disabled to so ONE can execute commands using sudo. The line to remove or comment out (by placing a # at the beginning of the line) is this one:

.. code::

    #Defaults requiretty

OpenNebula Configuration
------------------------

OpenNebula needs to know if it is going to use the XEN Driver. There are two sets of Xen VMM drivers, one for Xen version 3.x and other for 4.x, you will have to uncomment the version you will need. To achieve this for Xen version 4.x, uncomment these drivers in :ref:`/etc/one/oned.conf <oned_conf>`:

.. code::

        IM_MAD = [
            name       = "xen",
            executable = "one_im_ssh",
            arguments  = "xen" ]

        VM_MAD = [
            name       = "xen",
            executable = "one_vmm_exec",
            arguments  = "xen4",
            default    = "vmm_exec/vmm_exec_xen4.conf",
            type       = "xen" ]

``xen4`` drivers are meant to be used with Xen >=4.2 with ``xl``/``xenlight`` interface. You will need to stop ``xend`` daemon for this. For Xen 3.x and Xen 4.x with xm (with ``xend`` daemon) you will need to use ``xen3`` drivers.

.. warning:: :sub:`When using ``xen3`` drivers for Xen 4.x you should change the configuration file ``/var/lib/oneremotes/vmm/xen3/xenrc`` and uncomment the ``XM_CREDITS`` line.`

Usage
=====

The following are template attributes specific to Xen, please refer to the :ref:`template reference documentation <template>` for a complete list of the attributes supported to define a VM.

XEN Specific Attributes
-----------------------

DISK
~~~~

-  **driver**, This attribute defines the Xen backend for disk images, possible values are ``file:``, ``tap:aio:``... Note the trailing ``:``.

NIC
~~~

-  **model**, This attribute defines the type of the vif. This corresponds to the type attribute of a vif, possible values are ``ioemu``, ``netfront``...

-  **ip**, This attribute defines the ip of the vif and can be used to set antispoofing rules. For example if you want to use antispoofing with network-bridge, you will have to add this line to ``/etc/xen/xend-config.sxp``:

.. code::

       (network-script 'network-bridge antispoofing=yes')

OS
~~

-  **bootloader**, You can use this attribute to point to your ``pygrub`` loader. This way you wont need to specify the kernel/initrd and it will use the internal one. Make sure the kernel inside is domU compatible if using paravirtualization.

-  When no ``kernel``/``initrd`` or ``bootloader`` attributes are set then a HVM machine is created.

CONTEXT
~~~~~~~

-  **driver**, for the CONTEXT device, e.g. 'file:', 'phy:'...

Additional Attributes
---------------------

The **raw** attribute offers the end user the possibility of passing by attributes not known by OpenNebula to Xen. Basically, everything placed here will be written ad literally into the Xen deployment file.

.. code::

      RAW = [ type="xen", data="on_crash=destroy" ]

Tuning & Extending
==================

The driver consists of the following files:

-  ``/usr/lib/one/mads/one_vmm_exec`` : generic VMM driver.
-  ``/var/lib/one/remotes/vmm/xen`` : commands executed to perform actions.

And the following driver configuration files:

-  ``/etc/one/vmm_exec/vmm_exec_xen3/4.conf`` : This file is home for default values for domain definitions (in other words, OpenNebula templates). Let's go for a more concrete and VM related example. If the user wants to set a default value for KERNEL for all of their XEN domain definitions, simply edit the ``vmm_exec_xen.conf`` file and set a

.. code::

      OS = [ kernel="/vmlinuz" ]

into it. Now, when defining a ONE template to be sent to a XEN resource, the user has the choice of “forgetting” to set the **KERNEL** parameter, in which case it will default to /vmlinuz.

It is generally a good idea to place defaults for the XEN-specific attributes, that is, attributes mandatory for the XEN hypervisor that are not mandatory for other hypervisors. Non mandatory attributes for XEN but specific to them are also recommended to have a default.

-  ``/var/lib/one/remotes/vmm/xen/xenrc`` : This file contains environment variables for the driver. You may need to tune the values for ``XM_PATH``, if ``/usr/sbin/xm`` do not live in their default locations in the remote hosts. This file can also hold instructions to be executed before the actual driver load to perform specific tasks or to pass environmental variables to the driver. The syntax used for the former is plain shell script that will be evaluated before the driver execution. For the latter, the syntax is the familiar:

.. code::

      ENVIRONMENT_VARIABLE=VALUE

+---------------------+--------------------------------------------------------------+
| Parameter           | Description                                                  |
+=====================+==============================================================+
| IMAGE\_PREFIX       | This will be used as the default handler for disk hot plug   |
+---------------------+--------------------------------------------------------------+
| SHUTDOWN\_TIMEOUT   | Seconds to wait after shutdown until timeout                 |
+---------------------+--------------------------------------------------------------+
| FORCE\_DESTROY      | Force VM cancellation after shutdown timeout                 |
+---------------------+--------------------------------------------------------------+

See the :ref:`Virtual Machine drivers reference <devel-vmm>` for more information.

Credit Scheduler
================

Xen comes with a credit scheduler. The credit scheduler is a proportional fair share CPU scheduler built from the ground up to be work conserving on SMP hosts. This attribute sets a 16 bit value that will represent the amount of sharing this VM will have respect to the others living in the same host. This value is set into the driver configuration file, is not intended to be defined per domain.

Xen drivers come preconfigured to use this credit scheduler and uses the scale “1 OpenNebula CPU” = “256 xen scheduler credits”. A VM created with CPU=2.0 will have 512 xen scheduler credits. If you need to change this scaling parameter it can be configured in ``/etc/one/vmm_exec/vmm_exec_xen[3/4].conf``. The variable name is called ``CREDIT``.

