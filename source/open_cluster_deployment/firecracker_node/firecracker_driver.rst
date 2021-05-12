.. _fcmg:

================================================================================
Firecracker Driver
================================================================================

Requirements
============

Firecracker requires a Linux kernel version >= 4.14 and the KVM kernel module.

The specific information containing the supported platforms for Firecracker can be found in the `code repository <https://github.com/firecracker-microvm/firecracker#supported-platforms>`__.

Considerations & Limitations
================================================================================

microVM CPU Usage
--------------------------------------------------------------------------------

There are two main limitations regarding CPU usage for microVM:

- OpenNebula deploys microVMs by using `Firecracker's Jailer <https://github.com/firecracker-microvm/firecracker/blob/master/docs/jailer.md>`__. The Jailer takes care of increasing the security and isolation of the microVM and is the Firecracker's recommended way of deploying microVMs in production environments. The Jailer forces the microVM to be isolated in a NUMA node; OpenNebula takes care of evenly distributing microVMs among the available NUMA nodes. One of the following policies can be selected in ``/var/lib/one/remotes/etc/vmm/firecracker/firecrackerrc``:

   - ``rr``: schedule the microVMs in a RR way across NUMA nodes based on the VM id.
   - ``random``: schedule the microVMs randomly across NUMA nodes.

.. note:: Currently Firecracker only supports the isolation at NUMA level so OpenNebula NUMA & CPU pinning options are not available for Firecracker microVMs.

- Firecracker microVMs support hyperthreading but in a very specific way. When hyperthreading is enabled the number of threads per core will be always two (e.g., with ``VCPU=8`` the VM will have four cores with two threads each). In order to enable hyperthreading for microVM, the ``TOPOLOGY/THREADS`` value can be used in the microVM template as shown below:

.. code::

    TOPOLOGY = [
      CORES = "4",
      PIN_POLICY = "NONE",
      SOCKETS = "1",
      THREADS = "2" ]

Storage Limitations
--------------------------------------------------------------------------------

- Firecracker only supports ``raw`` format images.

- The Firecracker driver is only compatible with :ref:`NFS/NAS Datastores <nas_ds>` and :ref:`Local Storage Datastores <local_ds>`. Note that **``qcow2`` format is not supported**.

- As Firecracker Jailer performs a ``chroot`` operation under the microVM location, persistent images are not supported when using ``TM_MAD=shared``. In order to use persistent images when using ``TM_MAD=shared`` the system ``TM_MAD`` must be overwritten to use ``TM_MAD=ssh`` this can be easily achieved by adding ``TM_MAD_SYSTEM=ssh`` at the microVM template. More info on how to combine different ``TM_MADs`` can be found :ref:`here <shared-ssh-mode>`.

MicroVM Actions
--------------------------------------------------------------------------------

Some of the actions supported by OpenNebula for VMs and containers are not supported for microVM due to Firecracker's limitations. The following actions are not currently supported:

- ``Pause``
- ``Reboot``
- ``live disk-snapshots``
- ``disk-saveas``
- ``disk hot-plugging``
- ``nic hot-plugging``
- ``system snapshot``

Configuration
================================================================================

Driver Specifics Configuration
--------------------------------------------------------------------------------

Firecracker specifics configurations are available in the ``/var/lib/one/remotes/etc/vmm/firecracker/firecrackerrc`` file in the OpenNebula Front-end node. The following list contains the supported configuration attributes and a brief description of each one:

+----------------------------+-------------------------------------------------------+
| NAME                       | Description                                           |
+============================+=======================================================+
| ``:vnc``                   | Options to customize the VNC access to the            |
|                            | microVM. ``:width``, ``:height`` and ``:timeout``     |
|                            | can be set                                            |
+----------------------------+-------------------------------------------------------+
| ``:datastore_location``    | Default path for the datastores. This only needs to be|
|                            | changed if the corresponding value in oned.conf has   |
|                            | been modified                                         |
+----------------------------+-------------------------------------------------------+
| ``:uid``                   | UID for starting microVMs corresponds with ``--uid``  |
|                            | Jailer parameter                                      |
+----------------------------+-------------------------------------------------------+
| ``:gid``                   | GID for starting microVMs corresponds with ``--gid``  |
|                            | Jailer parameter                                      |
+----------------------------+-------------------------------------------------------+
| ``:firecracker_location``  | Firecracker binary location                           |
+----------------------------+-------------------------------------------------------+
| ``:shutdown_timeout``      | Timeout (in seconds) for executing cancel action if   |
|                            | shutdown gets stuck                                   |
+----------------------------+-------------------------------------------------------+
| ``:cgroup_location``       | Path where cgrup file system is mounted               |
+----------------------------+-------------------------------------------------------+
| ``:cgroup_cpu_shares``     | If true the cpu.shares value will be set according to |
|                            | the VM CPU value, if false the cpu.shares is left by  |
|                            | default which means that all the resources are shared |
|                            | equally across the VMs.                               |
+----------------------------+-------------------------------------------------------+
| ``:cgroup_delete_timeout`` | Timeout to wait for a cgroup to be empty after        |
|                            | shutdown/cancel a microVM                             |
+----------------------------+-------------------------------------------------------+

.. note:: Firecracker only supports cgroup v1.

Drivers Generic Configuration
--------------------------------------------------------------------------------

The Firecracker driver is enabled by default in OpenNebula ``/etc/one/oned.conf`` on your Front-end Host. The configuration parameters: ``-r``, ``-t``, ``-l``, ``-p`` and ``-s`` are already preconfigured with reasonable defaults. If you change them, you will need to restart OpenNebula.

Read the :ref:`oned Configuration <oned_conf_virtualization_drivers>` to understand these configuration parameters and :ref:`Virtual Machine Drivers Reference <devel-vmm>` to know how to customize and extend the drivers.

Storage
================================================================================

Unlike common VMs, Firecracker microVMs do not use full disk images (with partition tables, MBR...). Instead, Firecracker microVMs use a root file system image together with an uncompressed Linux Kernel binary file.

Root File System Images
--------------------------------------------------------------------------------

The root file system can be uploaded as a raw image (``OS`` type) to any OpenNebula image datastore. Once the image is available it can be added as a new disk to the microVM template.

Also, root file system images can be downloaded directly to OpenNebula from `Docker Hub <https://hub.docker.com/>`__, `Linux Containers <https://uk.images.linuxcontainers.org/>`__ and `Turnkey Linux <https://www.turnkeylinux.org/>`__ Marketplaces. Check :ref:`Public Marketplaces <public_marketplaces>` chapter for more information.

.. note:: Custom images can also be created by using common linux tools like ``mkfs`` command for creating the file system and ``dd`` for copying an existing file system inside the new one.

Kernels
--------------------------------------------------------------------------------

The kernels must be uploaded to a :ref:`Kernels & Files Datastore <file_ds>` with the "Kernel" type. Once the kernel is available it can be referenced by using the attribute ``KERNEL_DS`` inside ``OS`` section at microVM template.

Kernel images can build the desired kernel version, with the configuration attribute required for the use case. In order to improve the performance, the kernel image can be compiled with the minimal options required. Firecracker project provides a suggested configuration file in the `official repository <https://github.com/firecracker-microvm/firecracker/tree/master/resources>`__

.. _fc_network:

Networking
================================================================================

Firecracker works with all OpenNebula networking drivers.

As Firecracker does not manage the tap devices used for microVM networking, OpenNebula takes care of managing these devices and plugs then inside the pertinent bridge. In order to enable this functionality the following actions have to be carried out manually when networking is desired for MicroVMs.

.. code::

    # In the frontend for each driver to be use with firecracker
    $ cp /var/lib/one/remotes/vnm/hooks/pre/firecracker /var/lib/one/remotes/vnm/<networking-driver>/pre.d/firecracker
    $ cp /var/lib/one/remotes/vnm/hooks/clean/firecracker /var/lib/one/remotes/vnm/<networking-driver>/clean.d/firecracker
    $ onehost sync -f


.. note:: Execute the ``cp`` commands for every networking driver which is going to be used with MicroVMs. And make sure ``oneadmin`` user has enough permissions to run the scripts.

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

MicroVMs ``OS`` sections need to contain a ``KERNEL_DS`` attribute referencing a linux kernel from a File & Kernel datastore:

.. code::

    OS=[
      BOOT="",
      KERNEL_CMD="console=ttyS0 reboot=k panic=1 pci=off i8042.noaux i8042.nomux i8042.nopnp i8042.dumbkbd",
      KERNEL_DS="$FILE[IMAGE_ID=2]"]

Remote Access
-----------------------

MicroVMs supports remote access via VNC protocol which allows easy access to microVMs. The following section must be added to the microVM template to configure the VNC access:

.. code::

    GRAPHICS=[
      LISTEN="0.0.0.0",
      TYPE="VNC" ]

Troubleshooting
================================================================================

Apart from the :ref:`system logs <troubleshoot>`, Firecracker generates a microVMs log inside the `jailed` folder. This log can be found in: ``/var/lib/one/datastores/<sys_ds_id>/<vm_id>/logs.fifo``.

.. note:: This log cannot be forwarded outside the VM folder, as while the Firecracker microVMs run, the Firecracker process is isolated in their VM folder to increase the security. More information on how Firecracker isolates the microVM can be found in the Firecracker `official documentation <https://github.com/firecracker-microvm/firecracker/blob/main/docs/design.md#jailer-process>`__.
