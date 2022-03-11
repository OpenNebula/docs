.. _lxdmg:
.. _lxcmg:

================================================================================
LXC Driver
================================================================================

Requirements
============

- LXC version >= 3.0.3 installed on the host.
- cgroup version 1 or 2 hosts are required to implement resource control operations (e.g. CPU pinning, memory or swap limitations).

Considerations & Limitations
================================================================================

Privileged Containers and Security
--------------------------------------------------------------------------------

In order to ensure the security in a multitenant environment, by default, the containers created by the LXC driver will be unprivileged. The unprivileged containers will be deployed as ``root``. It will use ``600100001-600165537`` sub UID/GID range for mapping users/groups in order to increase security in case a malicious agent is able to escape the container.

To create a privileged container, the attribute ``LXC_UNPRIVILEGED = "no"`` needs to be added to the VM Template. The generated container will include a file with a set of container configuration parameters for privileged containers. This file is located in the frontend at **/var/lib/one/remotes/etc/vmm/lxc/profiles/profile_privileged** (see below for its contents). You can be fine tune this file if needed (don't forget to sync the file using the command `onehost sync`).

.. code::

    lxc.mount.entry = 'mqueue dev/mqueue mqueue rw,relatime,create=dir,optional 0 0'
    lxc.cap.drop = 'sys_time sys_module sys_rawio'
    lxc.mount.auto = 'proc:mixed'
    lxc.mount.auto = 'sys:mixed'
    lxc.cgroup.devices.deny = 'a'
    lxc.cgroup.devices.allow = 'b *:* m'
    lxc.cgroup.devices.allow = 'c *:* m'
    lxc.cgroup.devices.allow = 'c 136:* rwm'
    lxc.cgroup.devices.allow = 'c 1:3 rwm'
    lxc.cgroup.devices.allow = 'c 1:5 rwm'
    lxc.cgroup.devices.allow = 'c 1:7 rwm'
    lxc.cgroup.devices.allow = 'c 1:8 rwm'
    lxc.cgroup.devices.allow = 'c 1:9 rwm'
    lxc.cgroup.devices.allow = 'c 5:0 rwm'
    lxc.cgroup.devices.allow = 'c 5:1 rwm'
    lxc.cgroup.devices.allow = 'c 5:2 rwm'
    lxc.cgroup.devices.allow = 'c 10:229 rwm'
    lxc.cgroup.devices.allow = 'c 10:200 rwm'


CPU and NUMA Pinning
--------------------------

You can pin containers to host CPUs and NUMA nodes simply by adding a ``TOPOLOGY`` attribute to the VM Template, :ref:`see the use Virtual Topology and CPU Pinning guide <numa>`

Supported Storage Formats
--------------------------------------------------------------------------------

- Datablocks require formatting with a file system in order to be attached to a container.

- Disk images must be a file system, they cannot have partition tables.

.. _lxc_unsupported_actions:

Container Actions
--------------------------------------------------------------------------------

There are a number of regular features that are not implemented yet:
Some of the actions supported by OpenNebula for VMs are not implemented yet for LXC. The following actions are not currently supported:

- ``migration``
- ``live migration``
- ``live disk resize``
- ``save/restore``
- ``snapshots``
- ``disk-saveas``
- ``disk hot-plugging``
- ``nic hot-plugging``

PCI Passthrough
--------------------------------------------------------------------------------

PCI Passthrough is not currently supported for LXC containers.

Wild Containers
--------------------------------------------------------------------------------

Importing wilds containers that weren't deployed by OpenNebula is not currently supported.


Configuration
================================================================================

OpenNebula
--------------------------------------------------------------------------------

The LXC driver is enabled by default in OpenNebula ``/etc/one/oned.conf`` on your Front-end Host with reasonable defaults. Read the :ref:`oned Configuration <oned_conf_virtualization_drivers>` to understand these configuration parameters and :ref:`Virtual Machine Drivers Reference <devel-vmm>` to know how to customize and extend the drivers.

Driver
--------------------------------------------------------------------------------

LXC driver-specific configuration is available in ``/var/lib/one/remotes/etc/vmm/lxc/lxcrc`` on the OpenNebula Front-end node. The following list contains the supported configuration attributes and a brief description:

+----------------------------+--------------------------------------------------------------------+
| Parameter                  | Description                                                        |
+============================+====================================================================+
| ``:vnc``                   | Options to customize the VNC access to the                         |
|                            | microVM. ``:width``, ``:height``, ``:timeout``, and                |
|                            | ``:command`` can be set                                            |
+----------------------------+--------------------------------------------------------------------+
| ``:datastore_location``    | Default path for the datastores. This only need to be              |
|                            | changed if the corresponding value in oned.conf has                |
|                            | been modified                                                      |
+----------------------------+--------------------------------------------------------------------+
| ``:default_lxc_config``    | Path to the LXC default configuration file. This file              |
|                            | will be included in the configuration of every LXC                 |
|                            | container                                                          |
+----------------------------+--------------------------------------------------------------------+

Mount options configuration section also in lxcrc

+----------------------------+--------------------------------------------------------------------+
| ``:bindfs``                | Comma separated list of mount options used when shifting the       |
|                            | uid/gid with bindfs. See <bindfs -o> command help                  |
+----------------------------+--------------------------------------------------------------------+
| ``:dev_<fs>``              | Mount options for disk devices (in the host). Options are set per  |
|                            | fs type (e.g. dev_xfs, dev_ext3...)                                |
+----------------------------+--------------------------------------------------------------------+
| ``:disk``                  | Mount options for data DISK in the contianer (lxc.mount.entry)     |
+----------------------------+--------------------------------------------------------------------+
| ``:rootfs``                | Mount options for root fs in the container (lxc.rootfs.options)    |
+----------------------------+--------------------------------------------------------------------+
| ``:mountpoint``            | Default Path to mount data disk in the container. This can be      |
|                            | set per DISK using the TARGET attribute                            |
+----------------------------+--------------------------------------------------------------------+

Storage
================================================================================

LXC containers need a root file system image in order to boot. This image can be downloaded directly to OpenNebula from `Docker Hub <https://hub.docker.com/>`__, `Linux Containers <https://uk.images.linuxcontainers.org/>`__ and `Turnkey Linux <https://www.turnkeylinux.org/>`__ Marketplaces. Check the :ref:`Public Marketplaces <public_marketplaces>` chapter for more information. You can use LXC with NAS (file-based), SAN (lvm) or Ceph Datastores.

.. note:: Custom images can also be created by using common linux tools like the ``mkfs`` command for creating the file system and ``dd`` for copying an existing file system inside the new one. Also OpenNebula will preserve any custom id map present on the filesystem.

Networking
================================================================================

LXC containers are fully integrated with every OpenNebula networking driver.

Usage
================================================================================

Container Template
-----------------------

Container Templates can be defined by using the same attributes described in :ref:`Virtual Machine Template section <vm_templates>`.

.. code::

    CPU="1"
    MEMORY="146"
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

The LXC driver will create a swap limitation equal to the amount of memory definded in the VM Template. The attribute ``LXC_SWAP`` can be used to declare extra swap for the container.

Remote Access
-----------------------

Containers supports remote access via VNC protocol which allows easy access to them. The following section must be added to the container template to configure the VNC access:

.. code::

    GRAPHICS=[
      LISTEN="0.0.0.0",
      TYPE="VNC" ]

Additional Attributes
-----------------------

The ``RAW`` attribute allows us to add raw LXC configuration attributes to the final container deployment file. This permits us to set configuration attributes that are not directly supported by OpenNebula.

.. code::

    RAW = [
      TYPE = "lxc",
      DATA = "lxc.signal.reboot = 9" ]

.. note:: Each line of the ``DATA`` attribute must contain only an LXC configuration attribute and its corresponding value. If a provided attribute is already set by OpenNebula, it will be discarded and the original value will take precedence.

The ``LXC_PROFILES`` attribute implements a similar behavior than `LXD profiles <https://linuxcontainers.org/lxd/advanced-guide/#profiles>`__. It allows to include pre-defined LXC configuration to a container. In order to use a profile, the corresponding LXC configuration file must be available at ``/var/lib/one/remotes/etc/vmm/lxc/profiles``.

For example, if you want to use the profiles ``production`` and ``extra-performance``, you need to create the corresponding files containing the LXC configuration attributes (using lxc config syntax):

.. prompt:: bash $ auto

  $ ls -l /var/lib/one/remotes/etc/vmm/lxc/profiles
  ...
  -rw-r--r-- 1 oneadmin oneadmin 40 abr 26 12:35 extra-performance
  -rw-r--r-- 1 oneadmin oneadmin 35 abr 26 12:35 production

.. warning:: After defining the profiles, make sure ``oneadmin`` user has enough permission for reading them. Also, remember to use ``onehost sync`` command to make sure the changes are synced in the host. If the profile is not available in the host, the container will be deployed without including the corresponding profile configuration.

After defining the profiles they can be used by adding the ``PROFILES`` attribute to the VM Template:

.. code::

  PROFILES = "extra-performance, production"

Profiles, are implemented by using the LXC ``include`` configuration attribute, note that the profiles will be included in the provided order and this order might affect the final configuration of the container.
