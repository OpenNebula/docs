.. _kvmg:

===========
KVM Driver
===========

`KVM (Kernel-based Virtual Machine) <http://www.linux-kvm.org/>`__ is a complete virtualization technique for Linux. It offers full virtualization, where each Virtual Machine interacts with its own virtualized hardware. This guide describes the use of the KVM virtualizer with OpenNebula, please refer to KVM specific documentation for further information on the setup of the KVM hypervisor itself.

Requirements
============

The hosts must have a working installation of KVM, that usually requires:

-  CPU with VT extensions
-  libvirt >= 0.4.0
-  kvm kernel modules (kvm.ko, kvm-{intel,amd}.ko). Available from kernel 2.6.20 onwards.
-  the qemu user-land tools

Considerations & Limitations
============================

-  KVM currently only supports 4 IDE devices, for more disk devices you should better use SCSI or virtio. You have to take this into account when adding disks. See the :ref:`Virtual Machine Template documentation <template_disks_device_mapping>` for an explanation on how OpenNebula assigns disk targets.
-  By default live migrations are started from the host the VM is currently running. If this is a problem in your setup you can activate local live migration adding ``-l migrate=migrate_local`` to ``vmm_mad`` arguments.
-  If you get error messages similar to ``error: cannot close file: Bad file descriptor`` upgrade libvirt version. Version 0.8.7 has a  `bug related to file closing operations. <https://bugzilla.redhat.com/show_bug.cgi?format=multiple&id=672725>`__
-   In case you are using disks with a cache setting different to none may may have problems with live migration depending on the libvirt version. You can enable the migration adding the ``--unsafe`` parameter to the virsh command. The file to change is ``/var/lib/one/remotes/vmm/kvm/migrate``, change this:

    .. code-block:: bash

            exec_and_log "virsh --connect $LIBVIRT_URI migrate --live $deploy_id $QEMU_PROTOCOL://$dest_host/system" \
                "Could not migrate $deploy_id to $dest_host"

    to this:

    .. code-block:: bash

            exec_and_log "virsh --connect $LIBVIRT_URI migrate --live --unsafe $deploy_id $QEMU_PROTOCOL://$dest_host/system" \
                "Could not migrate $deploy_id to $dest_host"

    and execute ``onehost sync --force``.


Configuration
=============

KVM Configuration
-----------------

OpenNebula uses the libvirt interface to interact with KVM, so the following steps are required in the hosts to get the KVM driver running:

-  Qemu should be configured to not change file ownership. Modify ``/etc/libvirt/qemu.conf`` to include ``dynamic_ownership = 0``. To be able to use the images copied by OpenNebula, change also the user and group under which the libvirtd is run to “oneadmin”:

.. code::

    $ grep -vE '^($|#)' /etc/libvirt/qemu.conf
    user = "oneadmin"
    group = "oneadmin"
    dynamic_ownership = 0

.. warning:: Note that oneadmin's group may be other than oneadmin. Some distributions adds oneadmin to the cloud group. Use group = “cloud” above in that case.

-  The remote hosts must have the libvirt daemon running.
-  The user with access to these remotes hosts on behalf of OpenNebula (typically ``<oneadmin>``) has to pertain to the <libvirtd> and <kvm> groups in order to use the deaemon and be able to launch VMs.

.. warning:: If apparmor is active (by default in Ubuntu it is), you should add /var/lib/one to the end of /etc/apparmor.d/libvirt-qemu

.. code::

    owner /var/lib/one/** rw,

.. warning:: If your distro is using PolicyKit you can use this recipe by Jan Horacek to add the require privileges to ``oneadmin`` user:

.. code::

    # content of file: /etc/polkit-1/localauthority/50-local.d/50-org.libvirt.unix.manage-opennebula.pkla
    [Allow oneadmin user to manage virtual machines]
    Identity=unix-user:oneadmin
    Action=org.libvirt.unix.manage
    #Action=org.libvirt.unix.monitor
    ResultAny=yes
    ResultInactive=yes
    ResultActive=yes

OpenNebula uses libvirt's migration capabilities. More precisely, it uses the TCP protocol offered by libvirt. In order to configure the physical hosts, the following files have to be modified:

-  ``/etc/libvirt/libvirtd.conf`` : Uncomment “listen\_tcp = 1”. Security configuration is left to the admin's choice, file is full of useful comments to achieve a correct configuration. As a tip, if you don't want to use TLS for connections set ``listen_tls = 0``.
-  Add the listen option to libvirt init script:

   -  ``/etc/default/libvirt-bin`` : add **-l** option to ``libvirtd_opts``
   -  For RHEL based distributions, edit this file instead: ``/etc/sysconfig/libvirtd`` : uncomment ``LIBVIRTD_ARGS="--listen"``

OpenNebula Configuration
------------------------

OpenNebula needs to know if it is going to use the KVM Driver. To achieve this, uncomment these drivers in :ref:`/etc/one/oned.conf <oned_conf>`:

.. code::

        IM_MAD = [
            name       = "kvm",
            executable = "one_im_ssh",
            arguments  = "-r 0 -t 15 kvm" ]

        VM_MAD = [
            name       = "kvm",
            executable = "one_vmm_exec",
            arguments  = "-t 15 -r 0 kvm",
            default    = "vmm_exec/vmm_exec_kvm.conf",
            type       = "kvm" ]

.. _kvmg_working_with_cgroups_optional:

Working with cgroups (Optional)
-------------------------------

.. warning:: This section outlines the configuration and use of cgroups with OpenNebula and libvirt/KVM. Please refer to the cgroups documentation of your Linux distribution for specific details.

Cgroups is a kernel feature that allows you to control the amount of resources allocated to a given process (among other things). This feature can be used to enforce the amount of CPU assigned to a VM, as defined in its template. So, thanks to cgroups a VM with CPU=0.5 will get half of the physical CPU cycles than a VM with CPU=1.0.

Cgroups can be also used to limit the overall amount of physical RAM that the VMs can use, so you can leave always a fraction to the host OS.

The following outlines the steps need to configure cgroups, this should be **performed in the hosts, not in the front-end**:

-  Define where to mount the cgroup controller virtual file systems, at least memory and cpu are needed.
-  (Optional) You may want to limit the total memory devoted to VMs. Create a group for the libvirt processes (VMs) and the total memory you want to assign to them. Be sure to assign libvirt processes to this group, e.g. wih CGROUP\_DAEMON or in cgrules.conf. Example:

.. code::

    #/etc/cgconfig.conf

    group virt {
            memory {
                    memory.limit_in_bytes = 5120M;
            }
    }

    mount {
            cpu     = /mnt/cgroups/cpu;
            memory  = /mnt/cgroups/memory;
    }

.. code::

    # /etc/cgrules.conf

    *:libvirtd       memory          virt/

-  After configuring the hosts start/restart the cgroups service.
-  (Optional) If you have limited the amount of memory for VMs, you may want to set ``HYPERVISOR_MEM`` parameter in ``/etc/one/sched.conf``

That's it. OpenNebula automatically generates a number of CPU shares proportional to the CPU attribute in the VM template. For example, consider a host running 2 VMs (73 and 74, with CPU=0.5 and CPU=1) respectively. If everything is properly configured you should see:

.. code::

    /mnt/cgroups/cpu/sysdefault/libvirt/qemu/
    |-- cgroup.event_control
    ...
    |-- cpu.shares
    |-- cpu.stat
    |-- notify_on_release
    |-- one-73
    |   |-- cgroup.clone_children
    |   |-- cgroup.event_control
    |   |-- cgroup.procs
    |   |-- cpu.shares
    |   ...
    |   `-- vcpu0
    |       |-- cgroup.clone_children
    |       ...
    |-- one-74
    |   |-- cgroup.clone_children
    |   |-- cgroup.event_control
    |   |-- cgroup.procs
    |   |-- cpu.shares
    |   ...
    |   `-- vcpu0
    |       |-- cgroup.clone_children
    |       ...
    `-- tasks

and the cpu shares for each VM:

.. code::

    > cat /mnt/cgroups/cpu/sysdefault/libvirt/qemu/one-73/cpu.shares 
    512
    > cat /mnt/cgroups/cpu/sysdefault/libvirt/qemu/one-74/cpu.shares 
    1024

Udev Rules
----------

When creating VMs as a regular user, ``/dev/kvm`` needs to be chowned to the ``oneadmin`` user. For that to be persistent you have to apply the following UDEV rule:

.. code::

    # cat /etc/udev/rules.d/60-qemu-kvm.rules
    KERNEL=="kvm", GROUP="oneadmin", MODE="0660"

Usage
=====

The following are template attributes specific to KVM, please refer to the :ref:`template reference documentation <template>` for a complete list of the attributes supported to define a VM.

Default Attributes
------------------

There are some attributes required for KVM to boot a VM. You can set a suitable defaults for them so, all the VMs get needed values. These attributes are set in ``/etc/one/vmm_exec/vmm_exec_kvm.conf``. The following can be set for KVM:

-  emulator, path to the kvm executable. You may need to adjust it to your ditsro
-  os, the attraibutes: kernel, initrd, boot, root, kernel\_cmd, and arch
-  vcpu
-  features, attributes: acpi, pae
-  disk, attributes driver and cache. All disks will use that driver and caching algorithm
-  nic, attribute filter.
-  raw, to add libvirt attributes to the domain XML file.

For example:

.. code::

        OS   = [ 
          KERNEL = /vmlinuz,
          BOOT   = hd,
          ARCH   = "x86_64"]

        DISK = [ driver = "raw" , cache = "none"]

        NIC  = [ filter = "clean-traffic", model = "virtio" ]

        RAW  = "<devices><serial type=\"pty\"><source path=\"/dev/pts/5\"/><target port=\"0\"/></serial><console type=\"pty\" tty=\"/dev/pts/5\"><source path=\"/dev/pts/5\"/><target port=\"0\"/></console></devices>"

KVM Specific Attributes
-----------------------

DISK
~~~~

-  **type**, This attribute defines the type of the media to be exposed to the VM, possible values are: ``disk`` (default), ``cdrom`` or ``floppy``. This attribute corresponds to the ``media`` option of the ``-driver`` argument of the ``kvm`` command.

-  **driver**, specifies the format of the disk image; possible values are ``raw``, ``qcow2``... This attribute corresponds to the ``format`` option of the ``-driver`` argument of the ``kvm`` command.

-  **cache**, specifies the optional cache mechanism, possible values are “default”, “none”, “writethrough” and “writeback”.

-  **io**, set IO policy possible values are “threads” and “native”

NIC
~~~

-  **target**, name for the tun device created for the VM. It corresponds to the ``ifname`` option of the '-net' argument of the ``kvm`` command.

-  **script**, name of a shell script to be executed after creating the tun device for the VM. It corresponds to the ``script`` option of the '-net' argument of the ``kvm`` command.

-  **model**, ethernet hardware to emulate. You can get the list of available models with this command:

.. code::

    $ kvm -net nic,model=? -nographic /dev/null

-  **filter** to define a network filtering rule for the interface. Libvirt includes some predefined rules (e.g. clean-traffic) that can be used. `Check the Libvirt documentation <http://libvirt.org/formatnwfilter.html#nwfelemsRules>`__ for more information, you can also list the rules in your system with:

.. code::

    $ virsh -c qemu:///system nwfilter-list

Graphics
~~~~~~~~

If properly configured, libvirt and KVM can work with SPICE (`check this for more information <http://www.spice-space.org/>`__). To select it, just add to the ``GRAPHICS`` attribute:

-  ``type = spice``

Enabling spice will also make the driver inject specific configuration for these machines. The configuration can be changed in the driver configuration file, variable ``SPICE_OPTIONS``.

Virtio
~~~~~~

Virtio is the framework for IO virtualization in KVM. You will need a linux kernel with the virtio drivers for the guest, check `the KVM documentation for more info <http://www.linux-kvm.org/page/Virtio>`__.

If you want to use the virtio drivers add the following attributes to your devices:

-  ``DISK``, add the attribute ``DEV_PREFIX=vd``
-  ``NIC``, add the attribute ``model=virtio``

Additional Attributes
---------------------

The **raw** attribute offers the end user the possibility of passing by attributes not known by OpenNebula to KVM. Basically, everything placed here will be written literally into the KVM deployment file (**use libvirt xml format and semantics**).

.. code::

      RAW = [ type = "kvm",
              data = "<devices><serial type=\"pty\"><source path=\"/dev/pts/5\"/><target port=\"0\"/></serial><console type=\"pty\" tty=\"/dev/pts/5\"><source path=\"/dev/pts/5\"/><target port=\"0\"/></console></devices>" ]

Disk/Nic Hotplugging
--------------------

KVM supports hotplugging to the ``virtio`` and the ``SCSI`` buses. For disks, the bus the disk will be attached to is inferred from the ``DEV_PREFIX`` attribute of the disk template.

-  ``sd``: ``SCSI`` (default).
-  ``vd``: ``virtio``.

If ``TARGET`` is passed instead of ``DEV_PREFIX`` the same rules apply (what happens behind the scenes is that OpenNebula generates a ``TARGET`` based on the ``DEV_PREFIX`` if no ``TARGET`` is provided).

The configuration for the default cache type on newly attached disks is configured in ``/var/lib/one/remotes/vmm/kvm/kvmrc``:

.. code::

    # This parameter will set the default cache type for new attached disks. It
    # will be used in case the attached disk does not have an specific cache
    # method set (can be set using templates when attaching a disk).
    DEFAULT_ATTACH_CACHE=none

For Disks and NICs, if the guest OS is a Linux flavour, the guest needs to be explicitly tell to rescan the PCI bus. This can be done issuing the following command as root:

.. code::

    # echo 1 > /sys/bus/pci/rescan

Tuning & Extending
==================

The driver consists of the following files:

-  ``/usr/lib/one/mads/one_vmm_exec`` : generic VMM driver.
-  ``/var/lib/one/remotes/vmm/kvm`` : commands executed to perform actions.

And the following driver configuration files:

-  ``/etc/one/vmm_exec/vmm_exec_kvm.conf`` : This file is home for default values for domain definitions (in other words, OpenNebula templates).

It is generally a good idea to place defaults for the KVM-specific attributes, that is, attributes mandatory in the KVM driver that are not mandatory for other hypervisors. Non mandatory attributes for KVM but specific to them are also recommended to have a default.

-  ``/var/lib/one/remotes/vmm/kvm/kvmrc`` : This file holds instructions to be executed before the actual driver load to perform specific tasks or to pass environmental variables to the driver. The syntax used for the former is plain shell script that will be evaluated before the driver execution. For the latter, the syntax is the familiar:

.. code::

      ENVIRONMENT_VARIABLE=VALUE

The parameters that can be changed here are as follows:

+--------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Parameter                | Description                                                                                                                                                                                                       |
+==========================+===================================================================================================================================================================================================================+
| LIBVIRT\_URI             | Connection string to libvirtd                                                                                                                                                                                     |
+--------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| QEMU\_PROTOCOL           | Protocol used for live migrations                                                                                                                                                                                 |
+--------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| SHUTDOWN\_TIMEOUT        | Seconds to wait after shutdown until timeout                                                                                                                                                                      |
+--------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| FORCE\_DESTROY           | Force VM cancellation after shutdown timeout                                                                                                                                                                      |
+--------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| CANCEL\_NO\_ACPI         | Force VM's without ACPI enabled to be destroyed on shutdown                                                                                                                                                       |
+--------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| DEFAULT\_ATTACH\_CACHE   | This parameter will set the default cache type for new attached disks. It will be used in case the attached disk does not have an specific cache method set (can be set using templates when attaching a disk).   |
+--------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

See the :ref:`Virtual Machine drivers reference <devel-vmm>` for more information.

