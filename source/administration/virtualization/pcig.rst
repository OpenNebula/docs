.. _pcig:

===============
PCI Passthrough
===============


Most of the information is taken from http://www.firewing1.com/howtos/fedora-20/create-gaming-virtual-machine-using-vfio-pci-passthrough-kvm. The VGA parts are not needed for devices that are not graphic cards or if you don't want to output video signal from them.

The overall setup state was taken from a preconfigured machine Fedora 22 machine done by surfSARA.

Requirements
============

- The host that is going to be used for virtualization needs to support I/O MMU. For Intel processors this is called VT-d and for AMD processors is called AMD-Vi. The instructions are made for Intel branded processors but the process should be very similar for AMD.

- kernel >= 3.12
- libvirt >= 1.1.3
- kvm hypervisor

Machine Configuration
=====================

Kernel configuration
--------------------

The kernel must be configured to support I/O MMU and to blacklist any driver that could be accessing the PCI's that we want to use in our VMs. The parameter to enable I/O MMU is:

.. code::

    intel_iommu=on

We also need to tell the kernel to load the ``vfio-pci`` driver and blacklist the drivers for the selected cards. For example, for nvidia GPUs we can use these parameters:

.. code::

    rd.driver.pre=vfio-pci rd.driver.blacklist=nouveau

vfio loading driver in initrd
-----------------------------

The modules for vfio must be added to initrd. The list of modules are ``vfio vfio_iommu_type1 vfio_pci vfio_virqfd``. For example, if your system uses ``dracut`` add the file ``/etc/dracut.conf.d/local.conf`` with this line:


.. code::

    add_drivers+="vfio vfio_iommu_type1 vfio_pci vfio_virqfd"

and regenerate ``initrd``:

.. code::

    # dracut --force


Driver Blacklisting
-------------------

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
-------------------

I/O MMU separates PCI cards into groups to isolate memory operation between devices and VMs. To add the cards to vfio and assign a group to them we can use the scripts shared in the aforementioned web page.

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
------------------

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
====================

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
=====

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
        CLASS = "0403"
    ]

The device can be also specified without all the type values. For example, to get any PCI Express Root Ports this can be added to a VM tmplate:

.. code::

    PCI = [
        CLASS = "0604"
    ]

More than one ``PCI`` options can be added to attach more than one PCI device to the VM.



