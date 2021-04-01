.. _lxdmg:
.. _lxcmg:

================================================================================
LXC Driver
================================================================================

Requirements
============

OpenNebula LXC Driver requires the LXC version >= 3.0.3 to be installed on the Host.

Considerations & Limitations
================================================================================

Security
--------------------------------------------------------------------------------

In order to ensure the security in a multitenant environment, only unprivileged containers are supported by LXC drivers.

The unprivileged containers will be deployed as ``root``. It will use ``600100001-600165537`` sub UID/GID range for mapping users/groups in order to increase security in case a malicious agent is able to escape the container.

Storage Limitations
--------------------------------------------------------------------------------

- Datablocks require formatting with a file system in order to be attached to a container.

- Only file system images are supported.

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

Storage
================================================================================

LXC containers need a root file system image in order to boot. This image can be downloaded directly to OpenNebula from `Docker Hub <https://hub.docker.com/>`__, `Linux Containers <https://uk.images.linuxcontainers.org/>`__ and `Turnkey Linux <https://www.turnkeylinux.org/>`__ Marketplaces. Check the :ref:`Public Marketplaces <public_marketplaces>` chapter for more information.

.. note:: Custom images can also be created by using common linux tools like the ``mkfs`` command for creating the file system and ``dd`` for copying an existing file system inside the new one.

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
