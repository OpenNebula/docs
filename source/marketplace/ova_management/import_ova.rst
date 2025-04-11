.. _import_ova:

================
OVA Import
================

Requirements
================================================================================

The import tool will assume that the provided OVA has been exported from a VMware environment, user must make sure that the provided OVA is compatible with VMware environments. Other sources are currently not supported (i.e. Xen or VirtualBox).

When converting an OVA you will need enough space both in the ``/tmp`` folder and in the destination DS where the disk images are going to be imported.

Windows VirtIO drivers
--------------------------------------------------------------------------------

Before converting Windows VMs, download the required VirtIO drivers for the Windows VM distribution. These drivers can be downloaded from the `virtio-win repository <https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md>`__.

.. note:: The converted VM will reboot several times after instantiation in order to install and configure the VirtIO drivers.

Usage
================================================================================

It is possible to specify the target Datastore and VNET for the OVA to be imported. Refer to ``man oneswap`` for the complete documentation of the oneswap command. Available options for the ``oneswap import`` command are:

+--------------------------------------------+-----------------------------------------------------------------------+
|           Parameter                        |                              Description                              |
+============================================+=======================================================================+
| ``--ova file.ova | /path/to/ovf/files/``   | Path to the OVA file or folder containing the OVF files.              |
+--------------------------------------------+-----------------------------------------------------------------------+
| ``--datastore name | ID``                  | Name/ID of the Datastore to store the new Image. Accepts one or more  |
|                                            | Datastores (i.e. ``--datastore 101,102``). When more than one         |
|                                            | Datastore is provided, each disk will be allocated in a different one.|
+--------------------------------------------+-----------------------------------------------------------------------+
| ``--network name | ID``                    | Name/ID of the VNET to assign in the VM Template. Accepts one or more |
|                                            | VNETs (i.e. ``--network 0,1``). When more than one VNET is provided,  |
|                                            | each interface from the OVA will be assigned to each VNET.            |
+--------------------------------------------+-----------------------------------------------------------------------+
| ``--virtio /path/to/virtio.iso``           | Path to the ISO file with the VirtIO drivers for the Windows version. |
+--------------------------------------------+-----------------------------------------------------------------------+

If multiple network interfaces are detected when importing an OVA and only one VNET ID or not enough VNET IDs are provided for all interfaces, using ``--network ID``, the last one will be used for the rest of the interfaces after the last coincidence. The same will apply to Datastores using the ``--datastore ID`` option.

Example on importing OVF
--------------------------------------------------------------------------------

Example command on how to import an OVF using the Datastore ID 101 and VNET ID 1:

.. prompt:: text $ auto

    $ oneswap import --ova /ovas/vm-alma9/ --datastore 101 --network 1
    Running: virt-v2v -v --machine-readable -i ova /ovas/vm-alma9/ -o local -os /tmp/vm-alma9/conversions/ -of qcow2 --root=first

    Setting up the source: -i ova /home/onepoc/ovas/vm-alma9/

    (...)

    $ onetemplate list
    ID USER     GROUP    NAME               REGTIME
    63 onepoc   oneadmin vm-alma9    03/24 16:34:34

    $ onetemplate instantiate 63
    VM ID: 103

Example on importing OVA with multiple DS and VNET
--------------------------------------------------------------------------------

The source OVA has two disks and two NICs, as it can be seen from the .ovf file:

.. prompt:: text $ auto

    <DiskSection>
        <Info>List of the virtual disks</Info>
        <Disk ovf:capacityAllocationUnits="byte" ovf:format="http://www.vmware.com/interfaces/specifications/vmdk.html#streamOptimized" ovf:diskId="vmdisk1" ovf:capacity="8589934592" ovf:fileRef="file1"/>
        <Disk ovf:capacityAllocationUnits="byte" ovf:format="http://www.vmware.com/interfaces/specifications/vmdk.html#streamOptimized" ovf:diskId="vmdisk2" ovf:capacity="2147483648" ovf:fileRef="file2"/>
    </DiskSection>
    <NetworkSection>
        <Info>The list of logical networks</Info>
        <Network ovf:name="VM Network 0">
        <Description>The VM Network 0 network</Description>
        </Network>
        <Network ovf:name="VM Network 1">
        <Description>The VM Network 1 network</Description>
        </Network>
    </NetworkSection>

Example command on how to import an OVA with two disks and two network interfaces, importing each disk to a different Datastore and assigning each NIC to a different VNET:

.. prompt:: text $ auto

    $ oneswap import --ova /home/onepoc/ovas/ubuntu2404.ova --datastore 1,101 --network 1,0
    Running: virt-v2v -v --machine-readable -i ova /home/onepoc/ovas/ubuntu2404.ova -o local -os /tmp/ubuntu2404/conversions/ -of qcow2 --root=first

    Setting up the source: -i ova /home/onepoc/ovas/ubuntu2404.ova

    (...)

    $ onetemplate list
    ID USER     GROUP    NAME                  REGTIME
    101 onepoc   oneadmin ubuntu2404    04/10 12:55:03

The OS Image is imported in Datastore 1 and the Datablock Image is imported in Datastore 101, and the VM Template has one NIC using VNET 1 and a second NIC using VNET 0.

.. prompt:: text $ auto

    $ oneimage list
    ID USER     GROUP    NAME            DATASTORE     SIZE TYPE PER STAT RVMS
    151 onepoc   oneadmin ubuntu2404_1   NFS image       2G DB    No rdy     0
    150 onepoc   oneadmin ubuntu2404_0   default         8G OS    No rdy     0

    $ onetemplate show 101 | grep NIC -A 1
    NIC=[
        NETWORK_ID="1" ]
    NIC=[
        NETWORK_ID="0" ]

Context injection
================================================================================

OneSwap will detect the guest operating system and try to inject the context packages available from the `one-apps <https://github.com/opennebula/one-apps>`__ repository.

Context injection will be performed following these steps:

1. Install context using package manager for the distro. However, this step may fail and trigger the execution of the fallback context installation command:

.. prompt:: text $ auto

    Inspecting disk...Done (3.92s)
    Injecting one-context...Running: virt-customize -q -a /tmp/vm-alma9/conversions/vm-alma9-sda --run-command 'subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms' --run-command 'yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm' --copy-in /var/lib/one/context//one-context-6.10.0-3.el9.noarch.rpm:/tmp --install /tmp/one-context-6.10.0-3.el9.noarch.rpm --delete /tmp/one-context-6.10.0-3.el9.noarch.rpm --run-command 'systemctl enable NetworkManager.service || exit 0'
    Failed (6.31s)

2. Context will be installed using a fallback method of copying the context packages into the guest OS and installing it on the first boot in case the previous step fails. Sometimes it will be necessary to boot twice in order for this method to work.

.. prompt:: text $ auto

    Running: virt-customize -q -a /tmp/vm-alma9/conversions/vm-alma9-sda --firstboot-install epel-release --copy-in /var/lib/one/context//one-context-6.10.0-3.el9.noarch.rpm:/tmp --firstboot-install /tmp/one-context-6.10.0-3.el9.noarch.rpm --run-command 'systemctl enable network.service || exit 0'
    Success (42.24s)
    Context will install on first boot, you may need to boot it twice.

.. note:: If context injection does not work after importing, it is also possible to install one-context **before exporting the OVA** from VMware using the packages available in the one-apps repository and uninstalling VMware Tools. In this case it is important to be aware that the one-context service will get rid of any manual network configurations done to the guest OS and the VM won't be able to get the network configuration from VMware anymore.

Additional virt-v2v options
================================================================================

The following parameters can be tuned for virt-v2v, defaults will be applied if no options are provided.

+--------------------------------------------+-----------------------------------------------------------------------+
|           Parameter                        |                              Description                              |
+============================================+=======================================================================+
| ``--v2v-path /path/to/ovf/files/``         | Path to the OVA file or folder containing the OVF files.              |
|                                            | Default: virt-v2v                                                     |
+--------------------------------------------+-----------------------------------------------------------------------+
| ``--work-dir | -w /path/to/work/dir``      | Directory where disk conversion takes place, will make subdir for each|
|                                            | VM. Default: /tmp                                                     |
+--------------------------------------------+-----------------------------------------------------------------------+
| ``--format | -f name [ qcow2 | raw]``      | Disk format [ qcow2 | raw ].                                          |
|                                            | Default: qcow2                                                        |
+--------------------------------------------+-----------------------------------------------------------------------+
| ``--virtio /path/to/iso``                  | Full path of the win-virtio ISO file. Required to inject VirtIO       |
|                                            | drivers to Windows Guests.                                            |
+--------------------------------------------+-----------------------------------------------------------------------+
| ``--win-qemu-ga /path/to/iso``             | Install QEMU Guest Agent to a Windows guest.                          |
+--------------------------------------------+-----------------------------------------------------------------------+
| ``--qemu-ga``                              | Install qemu-guest-agent package to a Linux guest, useful with        |
|                                            | --custom or --fallback.                                               |
+--------------------------------------------+-----------------------------------------------------------------------+
| ``--delete-after``                         | Removes the leftover conversion directory in the working directory    |
|                                            | which contains the converted VM disks and descriptor files.           |
+--------------------------------------------+-----------------------------------------------------------------------+
| ``--vddk /path/to/vddk/``                  | Full path to the VDDK library, required for VDDK based transfer.      |
+--------------------------------------------+-----------------------------------------------------------------------+
| ``--virt-tools /path/to/virt-tools``       | Path to the directory containing rhsrvany.exe, defaults to            |
|                                            | /usr/local/share/virt-tools. See https://github.com/rwmjones/rhsrvany.|
+--------------------------------------------+-----------------------------------------------------------------------+
| ``--root option``                          | Choose the root filesystem to be converted. Can be ask, single, first |
|                                            | or /dev/sdX.                                                          |
+--------------------------------------------+-----------------------------------------------------------------------+
