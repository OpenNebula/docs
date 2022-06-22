.. _kvm_vgpu:

NVIDIA vGPU support
================================================================================

This section describes how to configure the hypervisor in order to use NVIDIA vGPU features.

BIOS
--------------------------------------------------------------------------------

You need to check that the following settings are enabled in your BIOS configuration:

- Enable SR-IOV
- Enable IOMMU

Note that the specific menu options where you need to activate these features depends on the motherboard manufacturer.

NVIDIA Drivers
--------------------------------------------------------------------------------

The NVIDIA drivers are proprietary, so you will probably need to download them separately. Please check the documentation for your Linux distribution. Once you have installed and rebooted your server you should be able to access the GPU information as follows:

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

Enable the NVIDIA vGPU
--------------------------------------------------------------------------------

.. warning:: The following steps assume that your graphic card supports SR-IOV, if not, please refer to official NVIDIA documentation in order to activate vGPU.

Finding the PCI
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. prompt:: bash $ auto

    $ lspci | grep NVIDIA
    41:00.0 3D controller: NVIDIA Corporation Device 2236 (rev a1)

In this example the address is ``41:00.0``. Then, we need to convert this to transformed-bdf format by replacing the colon and period with underscores, in our case: ``41_00_0``. Now, we can obtain the PCI name, and the full information about the NVIDIA GPU (e.g. max number of virtual functions):

.. prompt:: bash $ auto

    $ virsh nodedev-list --cap pci | grep 41_00_0
    pci_0000_41_00_0

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

.. important:: You may need to perform this operation every time you reboot your server.

.. prompt:: bash $ auto

    $ # /usr/lib/nvidia/sriov-manage -e slot:bus:domain.function
    $ /usr/lib/nvidia/sriov-manage -e 00:41:0000.0
    Enabling VFs on 00:41:0000.0

If you get an error while doing this operation, please double check that all the BIOS steps have been correctly performed. If everything goes well, you should get something similar to this:

.. prompt:: bash $ auto

    $ ls -l /sys/bus/pci/devices/0000:41:00.0/ | grep virtfn
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn0 -> ../0000:41:00.4
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn1 -> ../0000:41:00.5
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn10 -> ../0000:41:01.6
    ...
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn30 -> ../0000:41:04.2
    lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn31 -> ../0000:41:04.3


Configuring QEMU
--------------------------------------------------------------------------------

Finally, add the following udev rule:

.. prompt:: bash $ auto

    $ echo 'SUBSYSTEM=="vfio", GROUP="kvm", MODE="0666"' > /etc/udev/rules.d/opennebula-vfio.rules

    # Reload udev rules:
    $ udevadm control --reload-rules && udevadm trigger

.. note:: You can check full NVIDIA documentation `here <https://docs.nvidia.com/grid/latest/pdf/grid-vgpu-user-guide.pdf>`__.

Using the vGPU
--------------------------------------------------------------------------------

Once everything is set up, you can follow :ref:`these steps <pci_config>`.
