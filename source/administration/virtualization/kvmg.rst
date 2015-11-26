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
-  In case you are using disks with a cache setting different to ``none`` you may have problems with live migration depending on the libvirt version. You can enable the migration adding the ``--unsafe`` parameter to the virsh command. The file to change is ``/var/lib/one/remotes/vmm/kvm/kvmrc``. Uncomment the following line, and execute ``onehost sync --force`` afterwards:

    .. code-block:: bash

        MIGRATE_OPTIONS=--unsafe

- Modern qemu versions (>= 1.10) have support some extensions of the qcow2 format that are not compatible with older versions. By default the images are generated in this format. To make them work in previous versions they need to be converted:

    .. code-block:: bash

        qemu-img convert -f qcow2 -O qcow2 -o compat=0.10 <source image> <destination image>

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

-  VMs can not be migrated from hosts wirh SElinux active to machines with it inactive. To make it work in an infrastructure with mixed SElinux configuration you can disable VM labeling. This is done adding the following lines to ``/etc/libvirt/qemu.conf``:

.. code::

    security_driver = "none"
    security_default_confined = 0

-  The remote hosts must have the libvirt daemon running.
-  The user with access to these remotes hosts on behalf of OpenNebula (typically ``<oneadmin>``) has to pertain to the <libvirtd> and <kvm> groups in order to use the deaemon and be able to launch VMs.

.. warning:: If apparmor is active (by default in Ubuntu it is), you should add ``/var/lib/one`` to the end of ``/etc/apparmor.d/abstractions/libvirt-qemu``

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

OpenNebula uses libvirt's migration capabilities. More precisely, it uses the ``qemu+ssh`` protocol offered by libvirt. In order to configure the physical hosts, the following files have to be modified:

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
-  (Optional) If you have limited the amount of memory for VMs, you may want to set ``RESERVED_MEM`` parameter in host or cluster templates.

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

VCPUs are not pinned so most probably the virtual process will be changing the core it is using. In an ideal case where the VM is alone in the physical host the total amount of CPU consumed will be equal to VCPU plus any overhead of virtualization (for example networking). In case there are more VMs in that physical node and is heavily used then the VMs will compete for physical CPU time. In this case cgroups will do a fair share of CPU time between VMs (a VM with CPU=2 will get double the time as a VM with CPU=1).

In case you are not overcommiting (CPU=VCPU) all the virtual CPUs will have one physical CPU (even if it's not pinned) so they could consume the number of VCPU assigned minus the virtualization overhead and any process running in the host OS.

Udev Rules
----------

When creating VMs as a regular user, ``/dev/kvm`` needs to be chowned to the ``oneadmin`` user. For that to be persistent you have to apply the following UDEV rule:

.. code::

    # cat /etc/udev/rules.d/60-qemu-kvm.rules
    KERNEL=="kvm", GROUP="oneadmin", MODE="0660"

Usage
=====

The following are template attributes specific to KVM, please refer to the :ref:`template reference documentation <template>` for a complete list of the attributes supported to define a VM.

.. _kvmg_default_attributes:

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

+------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|       Parameter        |                                                                                                   Description                                                                                                   |
+========================+=================================================================================================================================================================================================================+
| LIBVIRT\_URI           | Connection string to libvirtd                                                                                                                                                                                   |
+------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| QEMU\_PROTOCOL         | Protocol used for live migrations                                                                                                                                                                               |
+------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| SHUTDOWN\_TIMEOUT      | Seconds to wait after shutdown until timeout                                                                                                                                                                    |
+------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| FORCE\_DESTROY         | Force VM cancellation after shutdown timeout                                                                                                                                                                    |
+------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| CANCEL\_NO\_ACPI       | Force VM's without ACPI enabled to be destroyed on shutdown                                                                                                                                                     |
+------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| DEFAULT\_ATTACH\_CACHE | This parameter will set the default cache type for new attached disks. It will be used in case the attached disk does not have an specific cache method set (can be set using templates when attaching a disk). |
+------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| MIGRATE\_OPTIONS       | Set options for the virsh migrate command                                                                                                                                                                       |
+------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

See the :ref:`Virtual Machine drivers reference <devel-vmm>` for more information.

.. _kvm_pci_passthrough:

PCI Passthrough
===============

It is possible to discover PCI devices in the hypervisors and assign them to Virtual Machines for the KVM hypervisor.

The setup and environment information is taken from http://www.firewing1.com/howtos/fedora-20/create-gaming-virtual-machine-using-vfio-pci-passthrough-kvm. You can safely ignore all the VGA related sections, for PCI devices that are not graphic cards, or if you don't want to output video signal from them.

.. warning:: The overall setup state was extracted from a preconfigured Fedora 22 machine. **Configuration for your distro may be different.**

Requirements
------------

- The host that is going to be used for virtualization needs to support `I/O MMU <https://en.wikipedia.org/wiki/IOMMU>`__. For Intel processors this is called VT-d and for AMD processors is called AMD-Vi. The instructions are made for Intel branded processors but the process should be very similar for AMD.

- kernel >= 3.12
- libvirt >= 1.1.3
- kvm hypervisor

Machine Configuration (Hypervisor)
----------------------------------

Kernel Configuration
~~~~~~~~~~~~~~~~~~~~

The kernel must be configured to support I/O MMU and to blacklist any driver that could be accessing the PCI's that we want to use in our VMs. The parameter to enable I/O MMU is:

.. code::

    intel_iommu=on

We also need to tell the kernel to load the ``vfio-pci`` driver and blacklist the drivers for the selected cards. For example, for nvidia GPUs we can use these parameters:

.. code::

    rd.driver.pre=vfio-pci rd.driver.blacklist=nouveau


Loading vfio Driver in initrd
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The modules for vfio must be added to initrd. The list of modules are ``vfio vfio_iommu_type1 vfio_pci vfio_virqfd``. For example, if your system uses ``dracut`` add the file ``/etc/dracut.conf.d/local.conf`` with this line:

.. code::

    add_drivers+="vfio vfio_iommu_type1 vfio_pci vfio_virqfd"

and regenerate ``initrd``:

.. code::

    # dracut --force


Driver Blacklisting
~~~~~~~~~~~~~~~~~~~

The same blacklisting done in the kernel parameters must be done in the system configuration. ``/etc/modprobe.d/blacklist.conf`` for nvidia GPUs:

.. code::

    blacklist nouveau
    blacklist lbm-nouveau
    options nouveau modeset=0
    alias nouveau off
    alias lbm-nouveau off

Alongside this configuration vfio driver should be loaded passing the id of the PCI cards we want to attach to VMs. For example, for nvidia Grid K2 GPU we pass the id ``10de:11bf``. File ``/etc/modprobe.d/local.conf``:

.. code::

    options vfio-pci ids=10de:11bf


vfio Device Binding
~~~~~~~~~~~~~~~~~~~

I/O MMU separates PCI cards into groups to isolate memory operation between devices and VMs. To add the cards to vfio and assign a group to them we can use the scripts shared in the `aforementioned web page <http://www.firewing1.com/howtos/fedora-20/create-gaming-virtual-machine-using-vfio-pci-passthrough-kvm>`__.

This script binds a card to vfio. It goes into ``/usr/local/bin/vfio-bind``:

.. code::

    #!/bin/sh
    modprobe vfio-pci
    for dev in "$@"; do
            vendor=$(cat /sys/bus/pci/devices/$dev/vendor)
            device=$(cat /sys/bus/pci/devices/$dev/device)
            if [ -e /sys/bus/pci/devices/\$dev/driver ]; then
                    echo $dev > /sys/bus/pci/devices/$dev/driver/unbind
            fi
            echo $vendor $device > /sys/bus/pci/drivers/vfio-pci/new_id
    done

The configuration goes into ``/etc/sysconfig/vfio-bind``. The cards are specified with PCI addresses. Addresses can be retrieved with ``lspci`` command. Make sure to prepend the domain that is usually ``0000``. For example:

.. code::

    DEVICES="0000:04:00.0 0000:05:00.0 0000:84:00.0 0000:85:00.0"

Here is a systemd script that executes the script. It can be written to ``/etc/systemd/system/vfio-bind.service`` and enabled:

.. code::

    [Unit]
    Description=Binds devices to vfio-pci
    After=syslog.target

    [Service]
    EnvironmentFile=-/etc/sysconfig/vfio-bind
    Type=oneshot
    RemainAfterExit=yes
    ExecStart=-/usr/local/bin/vfio-bind $DEVICES

    [Install]
    WantedBy=multi-user.target


qemu Configuration
~~~~~~~~~~~~~~~~~~

Now we need to give qemu access to the vfio devices for the groups assigned to the PCI cards. We can get a list of PCI cards and its I/O MMU group using this command:

.. code::

    # find /sys/kernel/iommu_groups/ -type l

In our example our cards have the groups 45, 46, 58 and 59 so we add this configuration to ``/etc/libvirt/qemu.conf``:

.. code::

    cgroup_device_acl = [
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
        "/dev/rtc","/dev/hpet", "/dev/vfio/vfio",
        "/dev/vfio/45", "/dev/vfio/46", "/dev/vfio/58",
        "/dev/vfio/59"
    ]

Driver Configuration
--------------------

The only configuration that is needed is the filter for the monitoring probe that gets the list of PCI cards. By default the probe lists all the cards available in a host. To narrow the list a filter configuration can be changed in ``/var/lib/one/remotes/im/kvm-probes.d/pci.rb`` and set a list with the same format as ``lspci``:

.. code::

    # This variable contains the filters for PCI card monitoring. The format
    # is the same as lspci and several filters can be added separated by commas.
    # A nil filter will retrieve all PCI cards.
    #
    # From lspci help:
    #     -d [<vendor>]:[<device>][:<class>]
    #
    # For example
    #
    # FILTER = '::0300' # all VGA cards
    # FILTER = '10de::0300' # all NVIDIA VGA cards
    # FILTER = '10de:11bf:0300' # only GK104GL [GRID K2]
    # FILTER = '8086::0300,::0106' # all Intel VGA cards and any SATA controller

Usage
-----

The basic workflow is to inspect the host information, either in the CLI or in Sunstone, to find out the available PCI devices, and to add the desired device to the template. PCI devices can be added by specifying VENDOR, DEVICE and CLASS, or simply CLASS. Note that OpenNebula will only deploy the VM in a host with the available PCI device. If no hosts match, an error message will appear in the Scheduler log.

CLI
~~~

A new table in ``onehost show`` command gives us the list of PCI devices per host. For example:

.. code::

    PCI DEVICES

       VM ADDR    TYPE           NAME
          00:00.0 8086:0a04:0600 Haswell-ULT DRAM Controller
          00:02.0 8086:0a16:0300 Haswell-ULT Integrated Graphics Controller
      123 00:03.0 8086:0a0c:0403 Haswell-ULT HD Audio Controller
          00:14.0 8086:9c31:0c03 8 Series USB xHCI HC
          00:16.0 8086:9c3a:0780 8 Series HECI #0
          00:1b.0 8086:9c20:0403 8 Series HD Audio Controller
          00:1c.0 8086:9c10:0604 8 Series PCI Express Root Port 1
          00:1c.2 8086:9c14:0604 8 Series PCI Express Root Port 3
          00:1d.0 8086:9c26:0c03 8 Series USB EHCI #1
          00:1f.0 8086:9c43:0601 8 Series LPC Controller
          00:1f.2 8086:9c03:0106 8 Series SATA Controller 1 [AHCI mode]
          00:1f.3 8086:9c22:0c05 8 Series SMBus Controller
          02:00.0 8086:08b1:0280 Wireless 7260

- **VM**: The VM ID using that specific device. Empty if no VMs are using that device.
- **ADDR**: PCI Address.
- **TYPE**: Values describing the device. These are VENDOR:DEVICE:CLASS. These values are used when selecting a PCI device do to passthrough.
- **NAME**: Name of the PCI device.

To make use of one of the PCI devices in a VM a new option can be added selecting which device to use. For example this will ask for a ``Haswell-ULT HD Audio Controller``:

.. code::

    PCI = [
        VENDOR = "8086",
        DEVICE = "0a0c",
        CLASS  = "0403"
    ]

The device can be also specified without all the type values. For example, to get any PCI Express Root Ports this can be added to a VM tmplate:

.. code::

    PCI = [
        CLASS = "0604"
    ]

More than one ``PCI`` options can be added to attach more than one PCI device to the VM.

Sunstone
~~~~~~~~

In Sunstone the information is displayed in the **PCI** tab:

|image1|

To add a PCI device to a template, select the **Other** tab:

|image2|

.. |image1| image:: /images/sunstone_host_pci.png
.. |image2| image:: /images/sunstone_template_pci.png

.. _enabling_qemu_guest_agent:

Enabling QEMU Guest Agent
=========================

QEMU Guest Agent allows the communication of some actions with the guest OS. This agent uses a virtio serial connection to send and receive commands. One of the interesting actions is that it allows to freeze the filesystem before doing an snapshot. This way the snapshot won't contain half written data. Filesystem freeze will only be used  with ``CEPH`` and ``qcow2`` storage drivers.

The agent package needed in the Guest OS is available in most distributions. Is called ``qemu-guest-agent`` in most of them. If you need more information you can follow these links:

* https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Virtualization_Deployment_and_Administration_Guide/chap-QEMU_Guest_Agent.html
* http://wiki.libvirt.org/page/Qemu_guest_agent
* http://wiki.qemu.org/Features/QAPI/GuestAgent

To enable the communication channel with the guest agent this line must be present in ``/etc/one/vmm_exec/vmm_exec_kvm.conf``:

.. code::

    RAW = "<devices><channel type='unix'><source mode='bind'/><target type='virtio' name='org.qemu.guest_agent.0'/></channel></devices>"

Importing VMs
=============

VMs running on KVM hypervisors that were not launched through OpenNebula can be :ref:`imported in OpenNebula <import_wild_vms>`. It is important to highlight that, besides the limitations explained in the host guide, the "Poweroff" operation is not available for these imported VMs in KVM.

Multiple Actions per Host
=========================

.. warning:: This feature is experimental. Some modifications to the code must be done before this is a recommended setup.

By default the drivers use a unix socket to communicate with the libvirt daemon. This method can only be safely used by one process at a time. To make sure this happens the drivers are configured to send only one action per host at a time. For example, there will be only one deployment done per host at a given time.

This limitation can be solved configuring libvirt to accept TCP connections  and OpenNebula to use this communication method.

Libvirt configuration
---------------------

Here is described how to configure libvirtd to accept unencrypted and unauthenticated TCP connections in a CentOS 7 machine. For other setup check your distribution and libvirt documentation.

Change the file ``/etc/libvirt/libvirtd.conf`` in each of the hypervisors and make sure that these parameters are set and have the following values:

.. code::

    listen_tls = 0
    listen_tcp = 1
    tcp_port = "16509"
    auth_tcp = "none"

You will also need to modify ``/etc/sysconfig/libvirtd`` and uncomment this line:

.. code::

    LIBVIRTD_ARGS="--listen"

After modifying these files the libvirt daemon must be restarted:

.. code::

    $ sudo systemctl restart libvirtd

OpenNebula configuration
------------------------

The VMM driver must be configured so it allows more than one action to be executed per host. This can be done adding the parameter ``-p`` to the driver executable. This is done in ``/etc/one/oned.conf`` in the VM_MAD configuration section:

.. code::

    VM_MAD = [
        name       = "kvm",
        executable = "one_vmm_exec",
        arguments  = "-t 15 -r 0 kvm -p",
        default    = "vmm_exec/vmm_exec_kvm.conf",
        type       = "kvm" ]

Change the file ``/var/lib/one/remotes/vmm/kvm/kvmrc`` so set a TCP endpoint for libvirt communication:

.. code::

    export LIBVIRT_URI=qemu+tcp://localhost/system

The scheduler configuration should also be changed to let it deploy more than one VM per host. The file is located at ``/etc/one/sched.conf`` and the value to change is ``MAX_HOST`` For example, to let the scheduler submit 10 VMs per host use this line:

.. code::

    MAX_HOST = 10

After this update the remote files in the nodes and restart opennebula:

.. code::

    $ onehost sync --force
    $ sudo systemctl restart opennebula


Troubleshooting
===============

image magic is incorrect
------------------------

When trying to restore the VM from a suspended state this error is returned:

``libvirtd1021: operation failed: image magic is incorrect``

It can be fixed by applying:

.. code::

    options kvm_intel nested=0
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
