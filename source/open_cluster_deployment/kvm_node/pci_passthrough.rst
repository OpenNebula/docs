.. _kvm_pci_passthrough:

PCI Passthrough
===============

It is possible to discover PCI devices in the Hosts and directly assign them to Virtual Machines in the KVM hypervisor.

The setup and environment information is taken from `here <https://stewartadam.io/howtos/fedora-20/create-gaming-virtual-machine-using-vfio-pci-passthrough-kvm>`__. You can safely ignore all the VGA related sections, those for PCI devices that are not graphic cards, or if you don't want to output video signal from them.

.. warning:: The overall setup state was extracted from a preconfigured Fedora 22 machine. **Configuration for your distro may be different.**

Requirements
------------

Virtualization Host must

* support `I/O MMU <https://en.wikipedia.org/wiki/IOMMU>`__ (processor features Intel VT-d or AMD-Vi).
* have Linux kernel >= 3.12

(instructions below are made for Intel branded processors but the process should be very similar for AMD)

Machine Configuration (Hypervisor)
----------------------------------

Kernel Configuration
~~~~~~~~~~~~~~~~~~~~

The kernel must be configured to support I/O MMU and to blacklist any driver that could be accessing the PCIs that we want to use in our VMs. The parameter to enable I/O MMU is:

.. code::

    intel_iommu=on

We also need to tell the kernel to load the ``vfio-pci`` driver and blacklist the drivers for the selected cards. For example, for NVIDIA GPUs we can use these parameters:

.. code::

    rd.driver.pre=vfio-pci rd.driver.blacklist=nouveau


Loading VFIO Driver in initrd
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The modules for vfio must be added to initrd. The list of modules are ``vfio vfio_iommu_type1 vfio_pci vfio_virqfd``. For example, if your system uses ``dracut``, add the file ``/etc/dracut.conf.d/local.conf`` with this line:

.. code::

    add_drivers+="vfio vfio_iommu_type1 vfio_pci vfio_virqfd"

and regenerate ``initrd``:

.. code::

    # dracut --force


Driver Blacklisting
~~~~~~~~~~~~~~~~~~~

The same blacklisting done in the kernel parameters must be done in the system configuration. ``/etc/modprobe.d/blacklist.conf`` for NVIDIA GPUs:

.. code::

    blacklist nouveau
    blacklist lbm-nouveau
    options nouveau modeset=0
    alias nouveau off
    alias lbm-nouveau off

Alongside this configuration the VFIO driver should be loaded passing the id of the PCI cards we want to attach to VMs. For example, for NVIDIA GRID K2 GPU we pass the id ``10de:11bf``. File ``/etc/modprobe.d/local.conf``:

.. code::

    options vfio-pci ids=10de:11bf


VFIO Device Binding
~~~~~~~~~~~~~~~~~~~

I/O MMU separates PCI cards into groups to isolate memory operation between devices and VMs. To add the cards to VFIO and assign a group to them we can use the scripts shared in the `aforementioned web page <http://www.firewing1.com/howtos/fedora-20/create-gaming-virtual-machine-using-vfio-pci-passthrough-kvm>`__.

This script binds a card to VFIO. It goes into ``/usr/local/bin/vfio-bind``:

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

The configuration goes into ``/etc/sysconfig/vfio-bind``. The cards are specified with PCI addresses. Addresses can be retrieved with the ``lspci`` command. Make sure to prepend the domain that is usually ``0000``. For example:

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


QEMU Configuration
~~~~~~~~~~~~~~~~~~

Now we need to give QEMU access to the VFIO devices for the groups assigned to the PCI cards. We can get a list of PCI cards and its I/O MMU group using this command:

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

The only configuration needed is the filter for the monitoring probe that gets the list of PCI cards. By default, the probe doesn't list any cards from a Host. To narrow the list, the configuration can be changed in ``/var/lib/one/remotes/etc/im/kvm-probes.d/pci.conf``. The following configuration attributes are available:

+--------------------+-------------------------------------------------------------------------------------+
| Parameter          | Description                                                                         |
+====================+=====================================================================================+
| ``:filter``        | *(List)* Filters by PCI ``vendor:device:class`` patterns (same as for ``lspci``)    |
+--------------------+-------------------------------------------------------------------------------------+
| ``:short_address`` | *(List)* Filters by short PCI address ``bus:device.function``                       |
+--------------------+-------------------------------------------------------------------------------------+
| ``:device_name``   | *(List)* Filters by device names with case-insensitive regular expression patterns  |
+--------------------+-------------------------------------------------------------------------------------+

All filters are applied on the final PCI cards list.

Example:

.. code::

    # This option specifies the main filters for PCI card monitoring. The format
    # is the same as used by lspci to filter on PCI card by vendor:device(:class)
    # identification. Several filters can be added as a list, or separated
    # by commas. The NULL filter will retrieve all PCI cards.
    #
    # From lspci help:
    #     -d [<vendor>]:[<device>][:<class>]
    #            Show only devices with specified vendor, device and  class  ID.
    #            The  ID's  are given in hexadecimal and may be omitted or given
    #            as "*", both meaning "any value"#
    #
    # For example:
    #   :filter:
    #     - '10de:*'      # all NVIDIA VGA cards
    #     - '10de:11bf'   # only GK104GL [GRID K2]
    #     - '*:10d3'      # only 82574L Gigabit Network cards
    #     - '8086::0c03'  # only Intel USB controllers
    #
    # or
    #
    #   :filter: '*:*'    # all devices
    #
    # or
    #
    #   :filter: '0:0'    # no devices
    #
    :filter: '*:*'

    # The PCI cards list restricted by the :filter option above can be even more
    # filtered by the list of exact PCI addresses (bus:device.func).
    #
    # For example:
    #   :short_address:
    #     - '07:00.0'
    #     - '06:00.0'
    #
    :short_address:
      - '00:1f.3'

    # The PCI cards list restricted by the :filter option above can be even more
    # filtered by matching the device name against the list of regular expression
    # case-insensitive patterns.
    #
    # For example:
    #   :device_name:
    #     - 'Virtual Function'
    #     - 'Gigabit Network'
    #     - 'USB.*Host Controller'
    #     - '^MegaRAID'
    #
    :device_name:
      - 'Ethernet'
      - 'Audio Controller'

Usage
-----

The basic workflow is to inspect the Host information, either in the CLI or in Sunstone, to find out the available PCI devices and to add the desired device to the template. PCI devices can be added by specifying ``VENDOR``, ``DEVICE`` and ``CLASS``, or simply ``CLASS``. Note that OpenNebula will only deploy the VM in a Host with the available PCI device. If no Hosts match, an error message will appear in the Scheduler log.

CLI
~~~

A new table in ``onehost show`` command gives us the list of PCI devices per Host. For example:

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

- ``VM`` - The VM ID using that specific device. Empty if no VMs are using that device.
- ``ADDR`` - PCI Address.
- ``TYPE`` - Values describing the device. These are VENDOR:DEVICE:CLASS. These values are used when selecting a PCI device do to passthrough.
- ``NAME`` - Name of the PCI device.

To make use of one of the PCI devices in a VM a new option can be added selecting which device to use. For example this will ask for a ``Haswell-ULT HD Audio Controller``:

.. code::

    PCI = [
      VENDOR = "8086",
      DEVICE = "0a0c",
      CLASS  = "0403" ]

The device can also be specified without all the type values. For example, to get any *PCI Express Root Ports* this can be added to a VM template:

.. code::

    PCI = [
      CLASS = "0604" ]

More than one ``PCI`` options can be added to attach more than one PCI device to the VM.

Sunstone
~~~~~~~~

In Sunstone the information is displayed in the **PCI** tab:

|image1|

To add a PCI device to a template, select the **Other** tab:

|image2|

Usage as Network Interfaces
---------------------------

It is possible use a PCI device as an NIC interface directly in OpenNebula. In order to do so you will need to follow the configuration steps mentioned in this guide, namely changing the device driver.

When defining a Network that will be used for PCI passthrough nics, please use either the ``dummy`` network driver or the ``802.1Q`` if you are using VLAN. In any case, type any random value into the ``BRIDGE`` field, and it will be ignored. For ``802.1Q`` you can also leave ``PHYDEV`` blank.

The :ref:`context packages <context_overview>` support the configuration of the following attributes:

* ``MAC``: It will change the mac address of the corresponding network interface to the MAC assigned by OpenNebula.
* ``IP``: It will assign an IPv4 address to the interface, assuming a ``/24`` netmask.
* ``IPV6``: It will assign an IPv6 address to the interface, assuming a ``/128`` netmask.
* ``VLAN_ID``: If present, it will create a tagged interface and assign the IPs to the tagged interface.

CLI
~~~

When a ``PCI`` in a template contains the attribute ``TYPE="NIC"``, it will be treated as a ``NIC`` and OpenNebula will assign a MAC address, a VLAN_ID, an IP, etc, to the PCI device.

This is an example of the PCI section of an interface that will be treated as a NIC:

.. code::

    PCI = [
      NETWORK = "passthrough",
      NETWORK_UNAME = "oneadmin",
      TYPE = "NIC",
      CLASS = "0200",
      DEVICE = "10d3",
      VENDOR = "8086" ]


Note that the order of appearence of the ``PCI`` elements and ``NIC`` elements in the template is relevant. They will be mapped to NICs in the order they appear, regardless of whether or not they're NICs of PCIs.

Sunstone
~~~~~~~~

In the Network tab, under advanced options check the **PCI Passthrough** option and fill in the PCI address. Use the rest of the dialog as usual by selecting a network from the table.

|image3|

.. |image1| image:: /images/sunstone_host_pci.png
.. |image2| image:: /images/sunstone_template_pci.png
.. |image3| image:: /images/sunstone_nic_passthrough.png
