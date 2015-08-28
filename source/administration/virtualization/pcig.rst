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


