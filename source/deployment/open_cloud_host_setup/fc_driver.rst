.. _fcmg:

================================================================================
Firecracker Driver
================================================================================

`Firecracker <https://firecracker-microvm.github.io/>`__ is a virtual machine monitor (VMM) that uses the Linux Kernel-based Virtual Machine (KVM) to create and manage microVMs. Firecracker has a minimalist design. It excludes unnecessary devices and guest functionality to reduce the memory footprint and attack surface area of each microVM. This improves security, decreases the startup time, and increases hardware utilization.

Requirements
============

Firecracker requires a Linux kernel >= 4.14 and KVM module.

.. _fcmg_limitations:

Considerations & Limitations
================================================================================

microVM CPU usage
--------------------------------------------------------------------------------

There are three main limitation regarding CPU usage for microVM:

- OpenNebula deploys microVMs by using `Firecracker's Jailer <https://github.com/firecracker-microvm/firecracker/blob/master/docs/jailer.md>`__. The `jailer` takes care of increasing the security and isolation of the microVM and is the Firecracker recommended way for deploying microVMs in production environments. The jailer force the microVM to be isolated in a NUMA node, OpenNebula takes care of evenly distribute microVMs among the available NUMA nodes. One of the following policies can be selected in ``/var/lib/one/remotes/etc/vmm/firecracker/firecrackerrc``:

   - ``rr``: schedule the microVMs in a RR way across NUMA nodes based on the VM id.
   - ``random``: schedule the microVMs randomly across NUMA nodes.

.. note:: Currently Firecracker only support the isolation at NUMA level so OpenNebula NUMA & CPU pinning options are not available for Firecracker microVMs.

- Firecracker microVMs support hyperthreading but in a very specific way, when hyperthreading is enabled the number of threads per core will be always 2 (i.e if `VCPU = 8` the VM will have 4 cores with 2 threads each). In order to enable hyperthreading for microVM the ``TOPOLOGY/THREADS`` value can be used in the microVM template as shown below:

.. code::

    TOPOLOGY = [
        CORES = "4",
        PIN_POLICY = "NONE",
        SOCKETS = "1",
        THREADS = "2" ]

- As Firecracker Jailer performs a ``chroot`` operation under the microVM location, persistent images are not supported when using ``TM_MAD=shared``. In order to use persistent images when using ``TM_MAD=shared`` the system ``TM_MAD`` must be overwritten to use ``TM_MAD=ssh`` this can be easily achieved by adding ``TM_MAD_SYSTEM=ssh`` at the microVM template. More info on how to combine different ``TM_MADs`` can be found :ref:`here <shared-ssh-mode>`.

MicroVM actions
--------------------------------------------------------------------------------

Some of the actions supported by OpenNebula for VMs and containers are not supported for microVM due to Firecracker limitations. The following actions are not currently supported:

- ``Pause``
- ``Reboot``
- ``live disk-snapshots``
- ``disk-saveas``
- ``disk hot-plugging``
- ``nic hot-plugging``
- ``system snapshot``


Configuration
================================================================================
There are some interaction options between Firecracker and OpenNebula configured in ``/var/lib/one/remotes/etc/vmm/firecracker/firecrackerrc``

+-----------------------+-------------------------------------------------------+
| NAME                  | Description                                           |
+=======================+=======================================================+
| vnc                   | Options to customize the VNC access to the            |
|                       | microVM. ``:width``, ``height`` and ``timeout``       |
|                       | can be set                                            |
+-----------------------+-------------------------------------------------------+
| datastore_location    | Default path for the datastores. This only need to be |
|                       | change if the corresponding value in oned.conf has    |
|                       | been modified                                         |
+-----------------------+-------------------------------------------------------+
| uid                   | UID for starting microVMs correspond with ``--uid``   |
|                       | jailer parameter                                      |
+-----------------------+-------------------------------------------------------+
| gid                   | GID for starting microVMs correspond with ``--gid``   |
|                       | jailer parameter                                      |
+-----------------------+-------------------------------------------------------+
| firecracker_location  | Firecracker binary location                           |
+-----------------------+-------------------------------------------------------+
| shutdown_timeout      | Timeout (in seconds) for executing cancel action if   |
|                       | shutdown gets stuck                                   |
+-----------------------+-------------------------------------------------------+
| cgroup_location       | Path where cgrup file system is mounted               |
+-----------------------+-------------------------------------------------------+
| cgroup_cpu_shares     | If true the cpu.shares value will be set according to |
|                       | the VM CPU value if false the cpu.shares is left by   |
|                       | default which means that all the resources are shared |
|                       | equally across the VMs.                               |
+-----------------------+-------------------------------------------------------+
| cgroup_delete_timeout | Timeout to wait a cgroup to be empty after            |
|                       | shutdown/cancel a microVM                             |
+-----------------------+-------------------------------------------------------+

Drivers
--------------------------------------------------------------------------------

The Firecracker driver is enabled by default in OpenNebula:

.. code-block::  bash

    #-------------------------------------------------------------------------------
    #  Firecracker Virtualization Driver Manager Configuration
    #    -r number of retries when monitoring a host
    #    -t number of threads, i.e. number of hosts monitored at the same time
    #    -l <actions[=command_name]> actions executed locally, command can be
    #        overridden for each action.
    #        Valid actions: deploy, shutdown, cancel, save, restore, migrate, poll
    #        An example: "-l migrate=migrate_local,save"
    #    -p more than one action per host in parallel, needs support from hypervisor
    #    -s <shell> to execute remote commands, bash by default
    #    -w Timeout in seconds to execute external commands (default unlimited)
    #-------------------------------------------------------------------------------
    VM_MAD = [
        NAME           = "firecracker",
        SUNSTONE_NAME  = "Firecracker",
        EXECUTABLE     = "one_vmm_exec",
        ARGUMENTS      = "-t 15 -r 0 firecracker",
        TYPE           = "xml",
        KEEP_SNAPSHOTS = "no",
    ]

The configuration parameters: ``-r``, ``-t``, ``-l``, ``-p`` and ``-s`` are already preconfigured with sane defaults. If you change them you will need to restart OpenNebula.

Read the :ref:`Virtual Machine Drivers Reference <devel-vmm>` for more information about these parameters, and how to customize and extend the drivers.

Storage
================================================================================

Datastores
--------------------------------------------------------------------------------

Firecracker driver is compatible with **Filesystem Datastores**. Regarding of Transfer Managers (``TM_MAD``) Firecracker support every ``TM_MAD`` supported by Filesystem Datastores but ``qcow2`` as Firecracker does not support ``qcow2`` images.

.. note:: Note that ``shared`` datastores have some limitations, check :ref:`Considerations & Limitations section <fcmg_limitations>`.

More information about Filesystem Datastores can be found :ref:`here <fs_ds>`.

Images & Kernels Disks
--------------------------------------------------------------------------------

Unlike VMs and containers, Firecracker microVMs does not use full disk images (including partition tables, MBR...). Instead Firecracker microVMs uses a root filesystem image and needs a linux Kernel binary.

Images
^^^^^^^^^^^^^^^^^^^^^

The root file system can be uploaded as a raw image (``OS`` type) to any OpenNebula image datastore. Once the image is available it can be added as a new disk to the microVM template.

Root file system images can be downloaded directly to OpenNebula from `Docker Hub <https://hub.docker.com/>`__ and from `Linux Containers - Image server <https://uk.images.linuxcontainers.org/>`__ as both are fully integrated with OpenNebula. Check :ref:`LXD Marketplace <market_lxd>` for more information.

Custom images can also be created by using common linux tools like `mkfs` command for creating the file system and `dd` for copying and existing file system inside the new one.

Kernels
^^^^^^^^^^^^^^^^^^^^^

The kernel image must be uploaded to a :ref:`Kernels & Files Datastore <file_ds>` with type kernel. Once the kernel is available it can be reference by using the attribute ``KERNEL_DS`` inside ``OS`` section at microVM template.

Kernel images can built the desired kernel version, with the configuration attribute required for the use case, in order to improve performance kernel should be build with the minimal options needed. Firecracker project provide their suggested configuration files in their `official repository <https://github.com/firecracker-microvm/firecracker/tree/master/resources>`__

.. _fc_network:

Network
================================================================================

Firecracker is fully integrated with every networking driver based on linux bridge, including:

- Bridged
- VLAN
- VXLAN
- Security Groups

Unlike qemu-KVM which do manage automatically the tap devices requires for VM networking Firecracker needs for this devices to be managed by an external agent. OpenNebula takes care of managing this tap devices and plug then inside the pertinent bridge. In order to enable this functionality the following actions have to be carried out manually when networking is desired for MicroVMs.

.. code::

    # In the frontend for each driver to be use with firecracker
    $ cp /var/lib/one/remotes/vnm/hooks/pre/firecracker /var/lib/one/remotes/vnm/<networking-driver>/pre.d/firecracker
    $ cp /var/lib/one/remotes/vnm/hooks/clean/firecracker /var/lib/one/remotes/vnm/<networking-driver>/clean.d/firecracker
    $ onehost sync -f


.. note:: Execute the ``cp`` commands for every networking driver which is going to be used with MicroVMs.

Usage
================================================================================

MicroVM Template
-----------------------

Below there is a minimum microVM Template:

.. code::

    CPU="1"
    MEMORY="146"
    VCPU="2"
    CONTEXT=[
      NETWORK="YES",
      SSH_PUBLIC_KEY="$USER[SSH_PUBLIC_KEY]" ]
    DISK=[
      IMAGE="Alpine Linux 3.11",
      IMAGE_UNAME="oneadmin" ]
    GRAPHICS=[
      LISTEN="0.0.0.0",
      TYPE="VNC" ]
    NIC=[
      NETWORK="vnet",
      NETWORK_UNAME="oneadmin",
      SECURITY_GROUPS="0" ]
    OS=[
      BOOT="",
      KERNEL_CMD="console=ttyS0 reboot=k panic=1 pci=off i8042.noaux i8042.nomux i8042.nopnp i8042.dumbkbd",
      KERNEL_DS="$FILE[IMAGE_ID=2]"]

Unlike VMs for microVMs the ``OS`` sections need to contains a ``KERNEL_DS`` attribute referencing a linux kernel from a File & Kernel datastore:

.. code::

    OS=[
    BOOT="",
    KERNEL_CMD="console=ttyS0 reboot=k panic=1 pci=off i8042.noaux i8042.nomux i8042.nopnp i8042.dumbkbd",
    KERNEL_DS="$FILE[IMAGE_ID=2]"]

VNC
-----------------------

As VMs and containers, MicroVMs supports VNC access which allows easy access to microVMs. It is configured the same way it's done for VMs and containers. The following section must be added to the microVM template:

.. code::

    GRAPHICS=[
    LISTEN="0.0.0.0",
    TYPE="VNC" ]
