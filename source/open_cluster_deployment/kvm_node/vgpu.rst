.. _kvm_vgpu:

NVIDIA vGPU support
================================================================================

This guide describes how to configure the hypervisor in order to use NVIDIA vGPU features.

BIOS
--------------------------------------------------------------------------------

.. warning:: The following steps have been performed in a Supermicro server using AMD processor, the changes may differ if using different stuff.

The goal of the settings are:

- Enable SR-IOV
- Enable IOMMU

In order to do that, you need to reboot your server and enter into BIOS setup:

- Advanced >> CPU configuration >> SVM Mode >> Enabled
- Advanced >> PCIe/PCI/PnP Configuration >> SR-IOV Support >> Enabled
- Advanced >> NB Configuration >> ACS Enable >> Enabled
- Advanced >> NB Configuration >> IOMMU >> Enabled
- Advanced >> ACPI settings >> PCI AER Support >> Enabled

Save the settings and boot your server again.

NVIDIA Drivers
--------------------------------------------------------------------------------

NVIDIA drivers are proprietary, so you need to request them. You can pay or use the evaluation ones, both of them can be requested here. We will provide instructions about how to install it on Ubuntu 20.04 server, but in other distributions it should be very similar.

- Download the drivers from the official site.
- Copy those drivers to the server you want to install them on.
- Run the command ``apt install ./nvidia-vgpu-ubuntu-510_510.47.03_amd64.deb``
- Reboot your server.

Verifying the Installation

.. prompt:: bash $ auto

    $ lsmod | grep vfio
    nvidia_vgpu_vfio       57344  0

    $ nvidia-smi
    Wed Feb  9 12:36:07 2022
    +-----------------------------------------------------------------------------+
    | NVIDIA-SMI 510.47.03    Driver Version: 510.47.03    CUDA Version: N/A      |
    |-------------------------------+----------------------+----------------------+
    | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
    |                               |                      |               MIG M. |
    |===============================+======================+======================|
    |   0  NVIDIA A10          On   | 00000000:41:00.0 Off |                    0 |
    |  0%   52C    P8    26W / 150W |      0MiB / 23028MiB |      0%      Default |
    |                               |                      |                  N/A |
    +-------------------------------+----------------------+----------------------+

    +-----------------------------------------------------------------------------+
    | Processes:                                                                  |
    |  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
    |        ID   ID                                                   Usage      |
    |=============================================================================|
    |  No running processes found                                                 |
    +-----------------------------------------------------------------------------+

Creating an NVIDIA vGPU
--------------------------------------------------------------------------------

.. warning:: The following steps assume that your graphic card supports SR-IOV, if not, please refer to official NVIDIA documentation in order to activate vGPU.

Finding the PCI
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. prompt:: bash $ auto

    $ lspci | grep NVIDIA
    41:00.0 3D controller: NVIDIA Corporation Device 2236 (rev a1)

In our case the address is ``41:00.0``, we need to transform this to transformed-bdf format, the PCI device BDF of the GPU with the colon and the period replaced with underscores, in our case: ``41_00_0``. With this, we can obtain the PCI name:

.. prompt:: bash $ auto

    $ virsh nodedev-list --cap pci | grep 41_00_0
    pci_0000_41_00_0

Finally, we can get the full information about the PCI:

.. prompt:: bash $ auto

    $ virsh nodedev-dumpxml pci_0000_41_00_0
    <device>
        <name>pci_0000_41_00_0</name>
        <path>/sys/devices/pci0000:40/0000:40:03.1/0000:41:00.0</path>
        <parent>pci_0000_40_03_1</parent>
        <driver>
            <name>nvidia</name>
        </driver>
        <capability type='pci'>
            <class>0x030200</class>
            <domain>0</domain>
            <bus>65</bus>
            <slot>0</slot>
            <function>0</function>
            <product id='0x2236'/>
            <vendor id='0x10de'>NVIDIA Corporation</vendor>
            <capability type='virt_functions' maxCount='32'/>
            <iommuGroup number='44'>
            <address domain='0x0000' bus='0x40' slot='0x03' function='0x1'/>
            <address domain='0x0000' bus='0x41' slot='0x00' function='0x0'/>
            <address domain='0x0000' bus='0x40' slot='0x03' function='0x0'/>
            </iommuGroup>
            <pci-express>
            <link validity='cap' port='0' speed='16' width='16'/>
            <link validity='sta' speed='2.5' width='16'/>
            </pci-express>
        </capability>
    </device>

Enabling Virtual Functions
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. important:: This step needs to be performed every time you reboot your server.

.. prompt:: bash $ auto

    $ # /usr/lib/nvidia/sriov-manage -e slot:bus:domain.function
    $ /usr/lib/nvidia/sriov-manage -e 00:41:0000.0
    Enabling VFs on 00:41:0000.0

If you get an error while doing this operation, please double check that all the BIOS steps have been correctly performed.

If everything goes well, you should get something similar to this:

.. prompt:: bash $ auto

    $ ls -l /sys/bus/pci/devices/0000:41:00.0/ | grep virtfn
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn0 -> ../0000:41:00.4
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn1 -> ../0000:41:00.5
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn10 -> ../0000:41:01.6
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn11 -> ../0000:41:01.7
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn12 -> ../0000:41:02.0
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn13 -> ../0000:41:02.1
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn14 -> ../0000:41:02.2
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn15 -> ../0000:41:02.3
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn16 -> ../0000:41:02.4
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn17 -> ../0000:41:02.5
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn18 -> ../0000:41:02.6
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn19 -> ../0000:41:02.7
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn2 -> ../0000:41:00.6
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn20 -> ../0000:41:03.0
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn21 -> ../0000:41:03.1
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn22 -> ../0000:41:03.2
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn23 -> ../0000:41:03.3
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn24 -> ../0000:41:03.4
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn25 -> ../0000:41:03.5
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn26 -> ../0000:41:03.6
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn27 -> ../0000:41:03.7
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn28 -> ../0000:41:04.0
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn29 -> ../0000:41:04.1
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn3 -> ../0000:41:00.7
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn30 -> ../0000:41:04.2
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn31 -> ../0000:41:04.3
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn4 -> ../0000:41:01.0
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn5 -> ../0000:41:01.1
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn6 -> ../0000:41:01.2
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn7 -> ../0000:41:01.3
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn8 -> ../0000:41:01.4
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn9 -> ../0000:41:01.5

.. note:: The number of virtual functions will depend on the parameter <capability type='virt_functions' maxCount='32'/>.

Configuring QEMU
--------------------------------------------------------------------------------

Add the following udev rule:


.. prompt:: bash $ auto

    $ echo 'SUBSYSTEM=="vfio", GROUP="kvm", MODE="0666"' > /etc/udev/rules.d//etc/udev/rules.d

    # Reload udev rules:
    $ udevadm control --reload-rules && udevadm trigger

.. note:: You can check full NVIDIA documentation `here <https://docs.nvidia.com/grid/latest/pdf/grid-vgpu-user-guide.pdf>`__.

Using the vGPU
--------------------------------------------------------------------------------

Once everything is set up, you can follow :ref:`these steps <pci_config>`.
